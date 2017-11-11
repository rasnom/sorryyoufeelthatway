class SessionsController < ApplicationController

  def create
    @user = AdminUser.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
    end

    redirect_back(fallback_location: '/')
  end

  def destroy
    session[:user_id] = nil
    redirect_back(fallback_location: '/')
  end

end
