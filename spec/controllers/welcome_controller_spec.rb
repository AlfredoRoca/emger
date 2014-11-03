require 'rails_helper'

RSpec.describe WelcomeController do
  
  describe "index" do

    it "renders the root page" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end  
end