require 'rails_helper'

RSpec.describe FollowupsController, :type => :controller do
  let(:emergency) { FactoryGirl.create :emergency }
  let(:followup)  { FactoryGirl.create :followup, emergency_id: emergency.id }

  describe "GET index" do

    it "returns http success" do
      get :index, emergency_id: emergency

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do 
      get :index, emergency_id: emergency

      expect(response).to render_template(:index)
    end

    it "renders the list of followups" do
      followup1 = FactoryGirl.create(:followup, emergency_id: emergency.id)
      followup2 = FactoryGirl.create(:followup, emergency_id: emergency.id)
      followup3 = FactoryGirl.create(:followup, emergency_id: emergency.id)
      get :index, emergency_id: emergency

      expect(assigns(:followups)).to match_array([followup1, followup2, followup3])
    end

  end

  describe "GET new" do

    it "returns http success" do
      get :new, emergency_id: emergency

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the new template" do 
      get :new, emergency_id: emergency

      expect(response).to render_template(:new)
    end

  end

  describe "GET edit" do

    it "returns http success" do
      get :edit, id: followup, emergency_id: emergency

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do 
      get :edit, id: followup, emergency_id: emergency

      expect(response).to render_template(:edit)
    end

    it "renders the info" do
      get :edit, id: followup, emergency_id: emergency

      expect(assigns(:followup)).to eq(followup)
    end

  end

  describe "GET show" do

    it "returns http success" do
      get :show, id: followup, emergency_id: emergency
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do 
      get :show, id: followup, emergency_id: emergency
      expect(response).to render_template(:show)
    end
    
    it "renders the info" do
      get :show, id: followup, emergency_id: emergency

      expect(assigns(:followup)).to eq(followup)
    end
    
  end

end
