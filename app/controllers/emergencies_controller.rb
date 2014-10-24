class EmergenciesController < ApplicationController
  before_action :load_emergency, only: [:edit, :update]

  def index
    @emergencies = Emergency.all.order("date DESC")
  end

  def edit
  end

  def show
  end

  def new
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

  def emergency_params
    params.require(:emergency).permit(:date, :status, :simulacrum)
  end

  def load_emergency
    @emergency = Emergency.find(params[:id])
  end
end
