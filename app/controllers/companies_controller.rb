class CompaniesController < ApplicationController
  before_action :load_company, only: [:edit, :update, :show, :destroy]

  def index
    @companies = Company.all.order("name ASC")
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      flash[:notice] = "Successfully created new company..."
      redirect_to companies_path
    else
      flash[:error] = "Sorry, cannot create new company. Review errors..."
      render :new
    end
  end

  def update
    if @company.save(company_params)
      flash[:notice] = "Successfully updated..."
      redirect_to companies_path
    else
      flash[:error] = "Sorry, cannot update. Review the errors..."
      render :edit
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @company.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to companies_url
  end

  private
  def company_params
    params.require(:company).permit(:name, :activity, :phone1, :email)
  end

  def load_company
    @company = Company.find(params[:id])
  end
end
