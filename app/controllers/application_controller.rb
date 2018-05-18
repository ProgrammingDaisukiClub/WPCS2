class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :staging_authentication, if: -> { ENV['staging'] == 'true' }
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_style

  def set_locale
    I18n.locale = lang_param
  end

  def default_url_options(options = {})
    options.merge(lang_param != I18n.default_locale.to_s ? { lang: lang_param } : {})
  end

  def lang_param
    params.fetch(:lang, I18n.default_locale.to_s)
  end

  def set_header_style
    @header_style = 'outside'
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def staging_authentication
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == ENV['admin_username'] && password == ENV['admin_password']
    end
  end
end
