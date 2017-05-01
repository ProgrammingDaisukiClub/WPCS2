class ProfileController < ApplicationController
  def show
    redirect_to new_user_session_url unless signed_in?
  end

  def edit
    redirect_to new_user_session_url unless signed_in?
    @user = current_user
  end
end
