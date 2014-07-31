class UsersController < ApplicationController
  before_action :logged_in_check, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    user = User.new(user_params)

    if user.save
      login!(user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end