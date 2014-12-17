class QuotesController < ApplicationController

  def calculate

  # 1. check params for carrier to filter into appropriate API query
    if params[:provider] == "usps"
      usps_calculation
    else
      render json: {error: "Must provide a postal carrier"}, status: :bad_request
    end
  end

  def usps_calculation
    usps = USPS.new(:login => ENV["USPS_USERNAME"])
    response = usps.find_rates(make_origin, make_destination, make_package)
    response_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    render json: response_rates
  end

# http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210
  def make_origin
    Location.new(
    :country => params[:origin_country],
    :state => params[:origin_state],
    :city => params[:origin_city],
    :zip => params[:origin_zip])
  end
  # Note to self, spaces after ? are represented by + signs

  # http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105
  def make_destination
    Location.new(
    :country => params[:destination_country],
    :state => params[:destination_state],
    :city => params[:destination_city],
    :zip => params[:destination_zip])
  end

  # http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105&package_lbs=16
  def make_package
    if params[:package_lbs].blank?
      render json: {error: "Must provide a package weight"}, status: :bad_request
    else
      Package.new((params[:package_lbs].to_i * 16), [15, 10, 7], :cylinder => false)
    end
  end

end
