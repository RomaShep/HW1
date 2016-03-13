class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Вход выполнен!"
    else
      flash.now.alert = "Неправильный пароль или email !!!!!"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Вы вышли из учетной записи!"
  end

private
  def session_params
    params.permit(:name, :password) #.permit(:name, :password)
  end  
end
