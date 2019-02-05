class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def admin_user!
    redirect_to(root_path) unless current_user.admin?
  end

  # Methods when Access denied
  def user_not_authorized(exception)
    respond_to do |format|
      if @current_user
        flash.now[:warning] = exception_message(exception)
        referer_page = request.referer || root_path
        format.any(:xlsx, :json, :js) { redirect_to(referer_page) }
        format.html { render 'users/sessions/access_denied', layout: @layout ? false : layout_name }
      else
        format.any(:html, :xlsx, :json, :js) do
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

  def layout_name
    @current_user.admin? ? 'admin' : 'application'
  end
end
