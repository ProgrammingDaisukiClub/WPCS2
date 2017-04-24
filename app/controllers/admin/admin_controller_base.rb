class Admin::AdminControllerBase < ApplicationController
  before_action :admin_authentication, if: -> { ENV['staging'] != 'true' }

  def admin_authentication
    # redirect_to new_admin_session_path unless admin_signed_in?
    # TODO Use Devise authentication instead of basic auth
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == ENV['admin_username'] && password == ENV['admin_password']
    end
  end
end
