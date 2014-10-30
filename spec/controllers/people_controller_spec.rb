require 'rails_helper'

RSpec.describe PeopleController, :type => :controller do

  describe "GET index" do
    
    it "returns http success" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "rendeers the index template" do
      get :index

      expect(response).to render_template(:index)
    end

    it "renders the list of people ordered alfabetically by lastname+name" do
      person1 = FactoryGirl.create(:person)
      person2 = FactoryGirl.create(:person)
      person3 = FactoryGirl.create(:person)
      person4 = FactoryGirl.create(:person)
      get :index

      expect(assigns(:people)).to match_array([person1, person2, person3, person4].sort_by {|p| p.lastname + p.name})
    end

  end

  describe "GET show" do

    let(:person) { FactoryGirl.create(:person) }

    it "returns http success" do
      get :show, id: person

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do 
      get :show, id: person

      expect(response).to render_template(:show)
    end

    it "renders the person information" do
      get :show, id: person

      expect(assigns(:person)).to eq(person)
    end

  end

  describe "GET edit" do

    let(:person) { FactoryGirl.create(:person) }

    it "returns http success" do
      get :edit, id: person

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the edit template" do 
      get :edit, id: person

      expect(response).to render_template(:edit)
    end

    it "renders the person information" do
      get :edit, id: person

      expect(assigns(:person)).to eq(person)
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

end
