require 'rails_helper'

RSpec.describe LoginController, :type => :controller do

  describe "POST #create (login)" do

    let(:user) { FactoryGirl.create(:person, name: "pepe", lastname: "lopez", email: "qw@qwe.com", password: "1")}
    
    it "authenticates user and redirects to root url index with id in session" do
      post :create, email: user.email, password: "1"
      session[:current_user_id] = user.id

      expect(response).to redirect_to(root_url)
      expect(session[:current_user_id]).to eq(user.id)
    end

    it "with wrong password flashes error and renders the new form again" do
      post :create, email: user.email, password: "wrong"

      expect(response).to render_template(:new)
      expect(session[:current_user_id]).to be nil
    end

    it "with wrong email flashes error and renders the new form again" do
      post :create, email: "wrong@a.com", password: "1"

      expect(response).to render_template(:new)
      expect(session[:current_user_id]).to be nil
    end

  end

  describe "DELETE #destroy (logout)" do

    let(:user) { FactoryGirl.create(:person, name: "pepe", lastname: "lopez", email: "email@a.com", password: "1") }
    
    it "deletes session id and redirects to root (JS format)" do
      session[:current_user_id] = 1
      delete :destroy, format: :js

      expect(session[:current_user_id]).to be nil
      expect(response.body).to eq("window.location.href='#{root_path}'")
    end

    it "deletes session id and redirects to root (HTML format)" do
      session[:current_user_id] = 1
      delete :destroy, format: :html

      expect(session[:current_user_id]).to be nil
      expect(response).to redirect_to(root_url)
    end

  end


end
