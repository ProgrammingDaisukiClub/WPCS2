class Admin::UsersController < Admin::ControllerBase
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
