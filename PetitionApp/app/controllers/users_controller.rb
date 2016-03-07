class UsersController < ApplicationController
  
  def all
    @users = User.all
  end

  def user_petitions
    @user_petitions = current_user.petitions
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_petitions_path, :notice => "Signed up!"
    else
      render "new"
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :second_name, :email, :password)
  end
end
