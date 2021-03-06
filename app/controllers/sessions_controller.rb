class SessionsController < ApplicationController

  def new
  end

  def create
    user = user_by_username_or_email
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = t(:invalid_login)
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
