class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def updata
    @user = User.find(params[:id])
    @user.updata
    redirect_to user_path
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end
