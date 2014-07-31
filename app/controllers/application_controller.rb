class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = Session.create!( {
      user_id: user.id,
      token: User.generate_session_token } ).token
  end

  def logout!(user)
    current_user.delete_session_token!(session[:session_token])
    session[:session_token] = nil
  end

  def already_logged_in
    redirect_to cats_url if current_user
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= Session.find_by_token(session[:session_token]).try(:user)
  end

  def not_logged_in_redirect
    redirect_to new_session_url unless !@current_user
  end

end
