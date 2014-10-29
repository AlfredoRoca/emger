class FollowupsController < ApplicationController
  before_action :load_followup, only: [:show, :edit, :update, :destroy]

  def index
    @followups = Followup.all
  end

  def new
    @followup = Followup.new
  end

  def create
    @followup = Followup.create(followup_params)
    if @followup.save
      flash[:notice] = "Successfully created new follow-up..."
      redirect_to emergency_url(@followup.emergency_id)
    else
      flash[:error] = "Sorry, cannot create new follow-up. Review the errors..."
      render :new
    end
  end

  def edit
  end

  def update
    if @followup.update(followup_params)
      flash[:notice] = "Successfully updated follow-up..."
      redirect_to emergency_url(@followup.emergency_id)
    else
      flash[:error] = "Sorry, cannot update. Review the errors..."
      render :edit
    end
  end

  def show
  end

  def destroy
  end

  private
  def followup_params
    params.require(:followup).permit(:title, :description, :emergency_id)
  end

  def load_followup
    @followup = Followup.find(params[:id])
  end
end
