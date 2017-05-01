class UsersController < ApplicationController
  def show; end

  def edit
    redirect_to new_user_session_url unless signed_in?
    @user = current_user
  end
end
