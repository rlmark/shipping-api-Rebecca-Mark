require 'rails_helper'

RSpec.describe QuoteController, :type => :controller do

  describe "GET calculate" do
    it "returns http success" do
      get :calculate
      expect(response).to have_http_status(:success)
    end
  end

end
