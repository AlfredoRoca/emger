require 'rails_helper'

RSpec.describe PlacesController, :type => :controller do

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

    it "renders list of places ordered alfabetically" do
      place1 = FactoryGirl.create(:place)
      place2 = FactoryGirl.create(:place)
      place3 = FactoryGirl.create(:place)
      place4 = FactoryGirl.create(:place)
      get :index

      expect(assigns(:places)).to match_array([place1, place2, place3, place4].sort_by {|p| p.name})
    end

  end

  describe "GET show" do

    let(:place) { FactoryGirl.create(:place) }

    it "returns http success" do
      get :show, id: place

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      get :show, id: place

      expect(response).to render_template("show")
    end

  end

  describe "GET edit" do

    let(:place) { FactoryGirl.create(:place) }

    it "returns http success" do
      get :edit, id: place

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do
      get :edit, id: place

      expect(response).to render_template("edit")
    end

  end

end
