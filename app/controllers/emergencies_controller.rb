class EmergenciesController < ApplicationController
  before_action :load_emergency, only: [:edit, :update, :show, :destroy, :close]

  def index
    @emergencies = Emergency.all.order("date DESC")
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
    if @emergency.update(emergency_params.merge(status: EMERGENCY_STATUS_CLOSED))
      flash[:notice] = "Emergency successfully closed..."
      redirect_to set_coil_path
    else
      flash[:error] = "Impossible to close the emergency. Review the errors..."
      render :show
    end
  end

  def create
    @emergency = Emergency.create(emergency_params.merge(status: EMERGENCY_STATUS_OPEN))
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

  private

  def emergency_params
    params.require(:emergency).permit(:date, :status, :simulacrum)
  end

  def load_emergency
    @emergency = Emergency.find(params[:id])
  end
end
