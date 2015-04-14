class WeatherController < ApplicationController
    require 'net/http'
    require 'uri'


  def index
      uri = URI.parse("http://weather.noaa.gov/cgi-bin/fmtbltn.pl?file=forecasts/marine/coastal/gm/gmz730.txt")
      http = Net::HTTP.new(uri.host, uri.port)
      @weather_forecast = http.request(Net::HTTP::Get.new(uri.fullpath)).body
  end

#def everything
#      uri = URI.parse("http://www.srh.noaa.gov/tlh/")
#      http = Net::HTTP.new(uri.host, uri.port)
#      @weather_forecast = http.request(Net::HTTP::Get.new(uri.fullpath)).body
#end


end
