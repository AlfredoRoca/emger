class FollowupsController < ApplicationController
  before_action :load_followup, only: [:show, :edit, :update, :destroy]

  def index
    @followups = Followup.all
  end

  def new
    @followup = Followup.new
  end

  def edit
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
