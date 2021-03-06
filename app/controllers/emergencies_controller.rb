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
    @open_emergencies_places = Emergency.open.map{|e| e.place}
    respond_to do |format|
      format.html
      format.json { render json: @open_emergencies_places }
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
      redirect_to clear_emergency_in_plc_path(@emergency.place)
    else
      flash[:error] = "Impossible to close the emergency. Review the errors..."
      render :show
    end
  end

  def close_by_place
    emergency = Emergency.find_by(place_id: params[:id])
    if emergency.update(status: Emergency::EMERGENCY_STATUS_CLOSED)
      flash[:notice] = "Emergency successfully closed..."
      place = emergency.place
      respond_to do |format|
        response = {"place" => place, "emergency" => emergency}
        format.json { render json: response }
      end
    else
      flash[:error] = "Impossible to close the emergency. Review the errors..."
      respond_to do |format|
        format.html render :show
        format.json { render json: "Impossible to close the emergency." }
      end
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

  def here_new
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

  def modbus_new_emergency
    # check if already exists an open emergency
    # if not, create a new one
    place = Place.find(params[:id])
    emergency = Emergency.open.find_by(place_id: params[:id])
    unless emergency
      emergency = Emergency.create()
        emergency.status      = Emergency::EMERGENCY_STATUS_OPEN
        emergency.place_id    = params[:id]
        emergency.date        = DateTime::now
        emergency.simulacrum  = false
      if emergency.save
        response = {"place" => place, "emergency" => emergency}
      else
        response = "Error saving new emergency. Params: #{params}"
        status   = 451
      end
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
