require 'rails_helper'

RSpec.describe CompaniesController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "renders index template" do
      get :index
      expect(response).to render_template(:index)
    end
    it "renders the list of companies ordered alfabetically" do
      company1 = FactoryGirl.create(:company)
      company2 = FactoryGirl.create(:company)
      company3 = FactoryGirl.create(:company)
      company4 = FactoryGirl.create(:company)
      get :index
      expect(assigns(:companies)).to match_array([company1, company2, company3, company4].sort_by {|c| c.name})
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "renders new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:company) { FactoryGirl.create(:company) }
    it "returns http success" do
      get :show, id: company
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "renders show template" do
      get :show, id: company
      expect(response).to render_template(:show)
    end
  end

  describe "GET edit" do
    let(:company) { FactoryGirl.create(:company) }
    it "returns http success" do
      get :edit, id: company
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "renders edit template" do
      get :edit, id: company
      expect(response).to render_template(:edit)
    end
  end

end
