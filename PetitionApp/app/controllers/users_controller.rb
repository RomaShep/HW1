class UsersController < ApplicationController
  
  def all
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Добро пожаловать!"
    else
      render "new"
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :second_name, :email, :password, :password_confirmation)
  end
end
