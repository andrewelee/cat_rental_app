class SessionsController < ApplicationController

  before_action :already_logged_in, only: [:new]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render text: "Wrong credentials"
    else
      login!(user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!(current_user)
    redirect_to new_session_url
  end

  private


end