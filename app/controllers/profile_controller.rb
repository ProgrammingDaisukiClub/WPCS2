class ProfileController < ApplicationController
  def show
    unless signed_in?
      redirect_to new_user_session_url
      nil
    end
  end

  def edit
    unless signed_in?
      redirect_to new_user_session_url
      return
    end
    @user = current_user
  end
end
