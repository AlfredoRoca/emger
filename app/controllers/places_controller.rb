class PlacesController < ApplicationController
  before_action :load_place, only: [:edit, :show, :update, :destroy]

  def load_pinned_places
    @places = Place.pinned
    render :json => @places
  end

  def index
    @places = Place.all.order("name ASC")
  end

  def show
  end

  def edit
  end

  def new
    @place = Place.new
  end

  def update
    if @place.update(place_params)
      flash[:notice] = "Successfully updated place..."
      redirect_to places_url
    else
      flash[:error] = "Sorry, connot update place. Review the errors..."
      render :edit
    end
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      flash[:notice] = "Successfully created new place..."
      redirect_to places_url
    else
      flash[:error] = "Sorry, cannot create new place. Review the errors..."
      render :new
    end
  end

  def destroy
    @place.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to places_url
  end

  private
  def place_params
    params.require(:place).permit(:name, :description, :coord_x, :coord_y)
  end

  def load_place
    @place = Place.find(params[:id])
  end
end
