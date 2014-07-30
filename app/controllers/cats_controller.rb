class CatsController < ApplicationController

  COLORS = ["Brown", "Black", "Grey", "Orange", "Calico"]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @colors = COLORS
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @colors = COLORS
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])


    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def destroy
    Cat.find(params[:id]).destroy
    redirect_to cats_url
  end

  private

  def cat_params
    params.require(:cat).permit(
      :name,
      :age,
      :birth_date,
      :sex,
      :color,
      :description
    )
  end

end