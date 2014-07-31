class CatRentalRequestsController < ApplicationController
  before_action :not_logged_in_redirect

  def index
    @rental_requests = CatRentalRequest.all
    render :index
  end

  def new
    @rental_request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    @rental_request = CatRentalRequest.new(rental_request_params)
    @rental_request.user_id = current_user.id

    if @rental_request.save
      redirect_to cat_url(@rental_request.cat_id)
    else
      @cats = Cat.all
      render :new
    end
  end

  def show
    @rental_request = CatRentalRequest.find(params[:id])
    render :show
  end

  def approve
    @rental_request = CatRentalRequest.find(params[:id])
    @rental_request.approve!
    redirect_to cat_url(Cat.find(@rental_request.cat_id))
  end

  def deny
    @rental_request = CatRentalRequest.find(params[:id])
    @rental_request.deny!
    redirect_to cat_url(Cat.find(@rental_request.cat_id))
  end

  private

  def rental_request_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end



end