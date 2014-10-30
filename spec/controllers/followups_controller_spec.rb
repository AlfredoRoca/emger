require 'rails_helper'

RSpec.describe FollowupsController, :type => :controller do

  describe "GET index" do

    it "returns http success" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do 
      get :index

      expect(response).to render_template(:index)
    end

    it "renders the list of followups" do
      followup1 = FactoryGirl.create(:followup)
      followup2 = FactoryGirl.create(:followup)
      followup3 = FactoryGirl.create(:followup)
      get :index

      expect(assigns(:followups)).to match_array([followup1, followup2, followup3])
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

  describe "GET edit" do

    let(:followup1) { FactoryGirl.create(:followup) }

    it "returns http success" do
      get :edit, id: followup1

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do 
      get :edit, id: followup1

      expect(response).to render_template(:edit)
    end

    it "renders the info" do
      get :edit, id: followup1

      expect(assigns(:followup)).to eq(followup1)
    end

  end

  describe "GET show" do

    let(:followup1) { FactoryGirl.create(:followup) }

    it "returns http success" do
      get :show, id: followup1
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do 
      get :show, id: followup1
      expect(response).to render_template(:show)
    end
    
    it "renders the info" do
      get :show, id: followup1

      expect(assigns(:followup)).to eq(followup1)
    end
    
  end

end
