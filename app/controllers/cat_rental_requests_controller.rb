class CatRentalRequestsController < ApplicationController

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

    if @rental_request.save
      redirect_to cat_url(@rental_request.cat_id)
    else
      @cats = Cat.all
      render :new
    end
  end

  private

  def rental_request_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end



end