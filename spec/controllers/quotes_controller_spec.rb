require 'rails_helper'

RSpec.describe QuotesController, :type => :controller do

  describe "GET calculate" do
    it "returns http success" do
      get :calculate, {provider: 'usps', package_weight: '24', destination_zip: 98105}
      expect(response).to have_http_status(:success)
    end

    context "Querying USPS API" do
      it "returns an error if missing package weight" do
        get :calculate, {provider: 'usps', package_weight: '', destination_zip: 98105}
        expect(response.code).to eq "400"
      end

      it "returns an error if missing destination zip" do
        get :calculate, {provider: 'usps', package_weight: '24', destination_zip: ''}
        expect(response.body).to include 'Must provide a destination address'
      end

      it "returns shipping info when all correct parameters are input" do
        get :calculate, {provider: 'usps', package_weight: '24', destination_zip: 98105}
        expect(response.body).to include "USPS Priority Mail"
      end
    end

    context "Querying FEDEX API" do
      it "returns an error if missing package weight" do
        get :calculate, {provider: 'fedex', package_weight: '', destination_zip: 98105}
        expect(response.code).to eq "400"
      end

      it "returns an error if missing destination zip" do
        get :calculate, {provider: 'fedex', package_weight: '24', destination_zip: ''}
        expect(response.body).to include 'Must provide a destination address'
      end

      # Note to self, FEDEX requires Country to work!
      it "returns shipping info when all correct parameters are input" do
        get :calculate, {provider: 'fedex', package_weight: '24', destination_country: "US", destination_zip: 98105}
        expect(response.body).to include "FedEx"
      end
    end

    context "Querying UPS API" do
      it "returns an error if missing package weight" do
        get :calculate, {provider: 'ups', package_weight: '', destination_zip: 98105}
        expect(response.code).to eq "400"
      end

      it "returns an error if missing destination zip" do
        get :calculate, {provider: 'ups', package_weight: '24', destination_zip: ''}
        expect(response.body).to include 'Must provide a destination address'
      end

      it "returns shipping info when all correct parameters are input" do
        get :calculate, {provider: 'ups', package_weight: '24', destination_zip: 98105}
        expect(response.body).to include "UPS"
      end
    end


  end

end
