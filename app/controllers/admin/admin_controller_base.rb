class Admin::AdminControllerBase < ApplicationController
  before_action :admin_authentication

  def admin_authentication
    redirect_to new_admin_session_path unless admin_signed_in?
  end
end
