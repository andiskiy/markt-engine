class LocalesController < ApplicationController
  def update
    locale = params[:locale].to_s.strip.to_sym
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
      flash[:success] = t('shared.language.success')
    else
      locale = I18n.default_locale
      flash[:danger] = t('shared.language.danger')
    end
    cookies.permanent[:my_locale] = locale
    redirect_to request.referer || root_path
  end
end
