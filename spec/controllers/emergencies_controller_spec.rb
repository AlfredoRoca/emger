require 'rails_helper'

RSpec.describe EmergenciesController, :type => :controller do

  describe "GET index" do

    it "returns http success" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index

      expect(response).to render_template("index")
    end
    
    it "shows the list of emergencies" do
      emergency1 = FactoryGirl.create :emergency
      emergency2 = FactoryGirl.create :emergency
      get :index

      expect(assigns(:emergencies)).to match_array([emergency1,emergency2])
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

    let(:emergency) { FactoryGirl.create(:emergency) }

    it "returns http success" do
      get :show, id: emergency

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      get :show, id: emergency

      expect(response).to render_template(:show)
    end

  end

  describe "GET edit" do

    let(:emergency) { FactoryGirl.create(:emergency) }
    
    it "returns http success" do
      get :edit, id: emergency

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do
      get :edit, id: emergency

      expect(response).to render_template(:edit)
    end

  end

end
