require 'rails_helper'

RSpec.describe QuotesController, :type => :controller do

  describe "GET calculate" do
    it "returns http success" do
      get :calculate
      expect(response).to have_http_status(:success)
    end

    context "Querying USPS API" do
      # it "returns an error if missing package weight" do
      #   get :calculate, {provider: 'usps', package_weight: '', origin_zip: 98275, destination_zip: 98105}
      #   expet(response.code).to equal 400
      # end
    end
  end

end
