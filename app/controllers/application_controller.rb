class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  include Pundit

  before_action :set_locale
  before_action :set_time_zone

  layout :set_layout

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_layout
    request.xhr? ? false : 'application'
  end

  def admin_user!
    redirect_to(root_path) unless current_user&.admin_or_higher?
  end

  # Methods when Access denied
  def user_not_authorized(exception)
    respond_to do |format|
      if @current_user
        flash.now[:warning] = exception_message(exception)
        format.any(:json, :js) { render json: { error: t('pundit.default'), status: :not_authorized } }
        format.html { render 'users/sessions/access_denied', layout: @layout ? false : current_layout }
      else
        format.any(:html, :json, :js) do
          flash[:warning] = exception.to_s
          redirect_to(root_path)
        end
      end
    end
  end

  def exception_message(exception)
    policy_name = exception.policy.class.to_s.underscore
    if exception.query.present?
      t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    else
      exception.to_s
    end
  end

  def current_layout
    controller_path.split('/')[0] == 'admin' ? 'admin' : 'application'
  end

  # Callbacks
  def set_categories
    @categories = Category.all
  end

  def set_purchase
    @purchase = current_user.purchases.find_or_create_by(status: Purchase.statuses['pending']) if current_user
  end

  def set_locale
    if cookies[:my_locale] && I18n.available_locales.include?(cookies[:my_locale].to_sym)
      locale = cookies[:my_locale].to_sym
    else
      locale = I18n.default_locale
      cookies.permanent[:my_locale] = locale
    end
    I18n.locale = locale
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user&.time_zone &&
                                          current_user.time_zone != Time.zone.name
  end
end
