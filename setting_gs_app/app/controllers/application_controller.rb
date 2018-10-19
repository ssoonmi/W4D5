class ApplicationController < ActionController::Base

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def ensure_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def ensure_not_logged_in
    redirect_to users_url if logged_in?
  end

  def log_in_user(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    redirect_to users_url
  end

  def log_out(user)
    user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def logged_in?
    !!current_user
  end

end
