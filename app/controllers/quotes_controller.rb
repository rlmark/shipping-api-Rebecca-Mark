require 'active_shipping'
include ActiveMerchant::Shipping
# magical rails: request, activerecord request. API doc that has methods.


# have a before action to make all things, in before action do the render. Then no double render.
# can assume that by the time it makes the quote, we can assume instance varibales are created. Call the find_rates function on instance variables instead.


class QuotesController < ApplicationController

before_action :make_package, :make_origin, :make_destination

  def calculate
    raise request.inspect
    if params[:provider] == "fedex"
      make_fedex_quote
    elsif params[:provider] == "usps"
      make_usps_quote
    elsif params[:provider] == "ups"
      make_ups_quote
    else
      render json: {error: "Must provide a postal carrier"}, status: :bad_request
    end
  end

  # http://localhost:3000/quotes/calculate?provider=ups&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105&package_weight=14
  def make_ups_quote
    ups = UPS.new(:login => ENV['UPS_LOGIN'], :password => ENV['UPS_KEY'], :key => ENV['UPS_KEY'])
    response = ups.find_rates(@origin, @destination, @package)
    response_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    render json: response_rates
  end

  # http://localhost:3000/quotes/calculate?provider=fedex&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105&package_weight=14
  def make_fedex_quote
    fedex = FedEx.new(test: true, :login => ENV['FEDEX_LOGIN'], :password => ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'])
    response = fedex.find_rates(@origin, @destination, @package)
    response_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    render json: response_rates
  end

  def make_usps_quote
    usps = USPS.new(:login => ENV["USPS_USERNAME"])
    response = usps.find_rates(@origin, @destination, @package)
    response_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    render json: response_rates
  end

# http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210
  def make_origin
    @origin = Location.new(
    :country => "US",
    :state => "WA",
    :city => "Seattle",
    :zip => "98105")
  end
  # Note to self, spaces after ? are represented by + signs

  # http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105
  def make_destination
    if params[:destination_zip].blank?
      render json: {error: "Must provide a destination address"}, status: :bad_request
    else
      @destination = Location.new(
      :country => params[:destination_country],
      :state => params[:destination_state],
      :city => params[:destination_city],
      :zip => params[:destination_zip])
    end
  end

  # http://localhost:3000/quotes/calculate?provider=usps&origin_country=US&origin_state=CA&origin_city=Beverly+Hills&origin_zip=90210&destination_country=US&destination_state=WA&destination_city=Seattle&destination_zip=98105&package_weight=16
  def make_package
    if params[:package_weight].blank?
      render json: {error: "Must provide a package weight"}, status: :bad_request
    else
      @package = Package.new((params[:package_weight].to_i * 16), [15, 10, 7], :cylinder => false)
    end
  end

end
