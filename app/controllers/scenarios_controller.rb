class ScenariosController < ApplicationController
  before_action :load_scenario, only: [:edit, :update, :show, :destroy]

  def index
    @scenarios = Scenario.all
  end

  def new
    @scenario = Scenario.new
  end

  def show
  end

  def edit
  end

  def create
    @scenario = Scenario.create(scenario_params)
    if @scenario.save
      flash[:notice] = "Successfully created new scenario..."
      redirect_to scenarios_url
    else
      flash[:error] = "Sorry, cannot create new scenario. Review errors..."
      render :new
    end
  end

  def update
    if @scenario.update(scenario_params)
      flash[:notice] = "Successfully updated..."
      redirect_to scenario_url(@scenario)
    else
      flash[:error] = "Sorry, impossible to update. Review the errors..."
      render :edit
    end
  end

  def destroy
    @scenario.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to scenarios_path
  end

  private

  def load_scenario
    @scenario = Scenario.find(params[:id])
  end

  def scenario_params
    params.require(:scenario).permit(:name, :description)
  end
end
