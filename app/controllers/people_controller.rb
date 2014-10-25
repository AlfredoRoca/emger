class PeopleController < ApplicationController
  before_action :load_person, only: [:show, :edit, :update, :destroy]

  def index
    @people = Person.all.order("lastname ASC, name ASC")
  end

  def show
  end

  def edit
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.create(person_params)
    if @person.save
      flash[:notice] = "Successfully created new person..."
      redirect_to people_url
    else
      flash[:error] = "Sorry, cannot create new person. Review the errors..."
      render :new
    end
  end

  def update
    if @person.update(person_params)
      flash[:notice] = "Successfully updated..."
      redirect_to people_url
    else
      flash[:error] = "Sorry, cannot update information. Review the errors..."
      render :edit
    end
  end

  private
  def load_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :lastname, :phone, :email, :company_id)
  end
end
