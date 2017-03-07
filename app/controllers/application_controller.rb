class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    I18n.locale = lang_param
  end

  def default_url_options(options = {})
    options.merge(lang_param != I18n.default_locale.to_s ? { lang: lang_param } : {})
  end

  def lang_param
    params.fetch(:lang, I18n.default_locale.to_s)
  end

private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
