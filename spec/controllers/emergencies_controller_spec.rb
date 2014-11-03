require 'rails_helper'

RSpec.describe EmergenciesController, :type => :controller do

  describe "GET index" do
    context "HTML" do

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

        expect(assigns(:emergencies)).to match_array([emergency1, emergency2])
      end

    end

    context "JSON" do

      it "returns http success" do
        get :index, format: "json"

        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "returns the list of open emergencies" do
        emergency1 = FactoryGirl.create :emergency
        emergency2 = FactoryGirl.create :emergency
        emergency3 = FactoryGirl.create :emergency, status: Emergency::EMERGENCY_STATUS_CLOSED
        get :index, format: "json"

        expect(assigns(:emergencies)).to match_array([emergency1, emergency2])
      end

    end

  end

  describe "GET places" do
    context "HTML" do

      it "returns http success" do
        get :places

        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the open emergencies places template" do
        get :places

        expect(response).to render_template("places")
      end
      
      it "shows the list of places of open emergencies" do
        place1 = FactoryGirl.create :place
        place2 = FactoryGirl.create :place
        emergency1 = FactoryGirl.create :emergency, place_id: place1.id
        emergency2 = FactoryGirl.create :emergency, place_id: place2.id
        get :places

        expect(assigns(:open_emergencies_places)).to eq([place1, place2])
      end

    end


    context "JSON" do

      it "returns the list of the places of open emergencies" do
        place1 = FactoryGirl.create :place
        place2 = FactoryGirl.create :place
        emergency1 = FactoryGirl.create :emergency, place_id: place1.id
        emergency2 = FactoryGirl.create :emergency, place_id: place2.id
        get :places, format: "json"

        expect(assigns(:open_emergencies_places)).to match_array([place1, place2])

      end

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
