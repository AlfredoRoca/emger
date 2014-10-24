class EmergenciesController < ApplicationController
  def index
    @emergencies = Emergency.all
  end

  def new
  end

  def show
  end
end
