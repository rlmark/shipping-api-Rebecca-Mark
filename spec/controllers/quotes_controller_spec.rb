require 'rails_helper'

RSpec.describe QuotesController, :type => :controller do

  describe "GET calculate" do
    it "returns http success" do
      get :calculate
      expect(response).to have_http_status(:success)
    end

    context "Querying USPS API" do
      
    end
  end

end
