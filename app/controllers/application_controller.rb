class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  rescue ActiveRecord::RecordNotFound => e
    logger.info e.to_s
    nil
  end
  helper_method :current_user

  def authorize!
    unless params[:format] == 'json'
      redirect_to '/auth/google_oauth2' and return unless current_user
    end
  end

  def sonos
    @sonos ||= EKHO::Sonos.new
  end

end
