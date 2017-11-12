class AdminController < ApplicationController
  before_action :authorize

  def index

  end

  private

  def current_user
    if session[:user_id]
      @current_user ||= AdminUser.find(session[:user_id])
    end
  end

  def authorize
    render 'login' unless current_user
  end

end
