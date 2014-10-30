require 'rails_helper'

RSpec.describe ScenariosController, :type => :controller do

  describe "GET index" do
    
    it "returns http success" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "render the index template" do
      get :index

      expect(response).to render_template(:index)
    end

    it "shows the list of scenarios" do
      scenario1 = FactoryGirl.create :scenario
      scenario2 = FactoryGirl.create :scenario
      get :index

      expect(assigns(:scenarios)).to match_array([scenario1, scenario2])
    end

  end

  describe "GET new" do

    it "returns http success" do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    
    it "renders the new template" do
      get :new

      expect(response).to render_template(:new)
    end

  end

  describe "GET show" do

    let(:scenario) { FactoryGirl.create(:scenario) }

    it "returns http success" do
      get :show, id: scenario

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    
    it "renders the show template" do
      get :show, id: scenario

      expect(response).to render_template(:show)
    end

  end

  describe "GET edit" do

    let(:scenario) { FactoryGirl.create(:scenario) }
    
    it "returns http success" do
      get :edit, id: scenario

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do
      get :edit, id: scenario

      expect(response).to render_template(:edit)
    end

  end

end
