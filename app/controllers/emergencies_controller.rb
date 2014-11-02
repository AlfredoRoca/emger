class EmergenciesController < ApplicationController
  before_action :load_emergency, only: [:edit, :update, :show, :destroy, :close]

  def index
    @emergencies = Emergency.open.order("date DESC")
    respond_to do |format|
      format.html
      format.json { render json: @emergencies }
    end
  end

  def places
    @emergencies = Emergency.open.map{|e| e.place}
    respond_to do |format|
      format.html
      format.json { render json: @emergencies }
    end
  end

  def edit
  end

  def show
  end

  def new
    @emergency = Emergency.new
  end

  def update
    if @emergency.update(emergency_params)
      flash[:notice] = "Successfully updated emergency info..."
      redirect_to emergencies_path
    else
      flash[:error] = "Sorry, update not possible. Review the errors"
      render :edit
    end
  end

  def close
    if @emergency.update(status: Emergency::EMERGENCY_STATUS_CLOSED)
      flash[:notice] = "Emergency successfully closed..."
      redirect_to write_clear_in_plc_url
    else
      flash[:error] = "Impossible to close the emergency. Review the errors..."
      render :show
    end
  end

  def create
    @emergency = Emergency.create(emergency_params.merge(status: Emergency::EMERGENCY_STATUS_OPEN))
    if @emergency.save
      flash[:notice] = "Successfully created the new emergency..."
      redirect_to emergency_path(@emergency)
    else
      flash[:error] = "Sorry, review the errors..."
      render :new
    end
  end

  def destroy
    @emergency.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to emergencies_url
  end

  def here_new_emergency
    place = Place.create()
      place.name = params[:name]
      place.description = params[:description]
      place.coord_x = params[:coord_x]
      place.coord_y = params[:coord_y]
    if place.save
      emergency = Emergency.create()
        emergency.status      = Emergency::EMERGENCY_STATUS_OPEN
        emergency.place_id    = place.id
        emergency.date        = DateTime::now
        emergency.simulacrum  = false
      if emergency.save
        response = {"place" => place, "emergency" => emergency}
      else
        response = "Error saving new emergency. Params: #{params}"
        status   = 451
      end
    else
      response = "Error saving new place: #{place.errors.full_messages.each{|msg| msg}}"
      status   =  450
    end
      render json: response
  end

  private

  def emergency_params
    params.require(:emergency).permit(:date, :status, :simulacrum, :place_id)
  end

  def load_emergency
    @emergency = Emergency.find(params[:id])
  end
end
