require 'rails_helper'

RSpec.describe QuotesController, :type => :controller do

  describe "GET calculate" do
    it "returns http success" do
      get :calculate, {provider: 'usps', package_weight: '24', origin_zip: 98275, destination_zip: 98105}
      expect(response).to have_http_status(:success)
    end

    context "Querying USPS API" do
      it "returns an error if missing package weight" do
        get :calculate, {provider: 'usps', package_weight: '', origin_zip: 98275, destination_zip: 98105}
        expect(response.code).to eq "400"
      end

      it "returns an error if missing origin zip" do
        get :calculate, {provider: 'usps', package_weight: '24', origin_zip: '', destination_zip: 98105}
        expect(response.body).to include 'Must provide an origin address'
      end

      it "returns an error if missing destination zip" do
        get :calculate, {provider: 'usps', package_weight: '24', origin_zip: 98275, destination_zip: ''}
        expect(response.body).to include 'Must provide a destination address'
      end
    end
  end

end
