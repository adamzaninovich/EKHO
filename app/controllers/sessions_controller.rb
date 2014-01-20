class SessionsController < ApplicationController

  def create
    user = User.from_omniauth env["omniauth.auth"]
    if user
      GlassSubscribeWorker.perform_async user.id
      session[:user_id] = user.id
      redirect_to root_url, notice: "<strong>Welcome #{user.name}!</strong> You have signed in with Google"
    else
      redirect_to root_url, alert: "Something went wrong"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You have been signed out"
  end

end
