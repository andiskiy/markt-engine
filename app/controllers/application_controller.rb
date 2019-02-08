class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def admin_user!
    redirect_to(root_path) unless current_user.admin_or_higher?
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
end
