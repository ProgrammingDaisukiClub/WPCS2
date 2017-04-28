class Admin::ControllerBase < ApplicationController
  before_action :admin_authentication

  def admin_authentication
    raise ActionController::RoutingError 'not found' unless signed_in? && current_user.admin_role
  end
end
