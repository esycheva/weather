#! /usr/bin/env ruby

# accu_weather_client.rb - клиет для взаимодействи с AccuWeather API

require 'net/http'

class AccuWeatherClient
    def initialize
        @hostname = 'http://dataservice.accuweather.com'
        @apikey = Rails.configuration.accu_weather['apikey']
        @location_key = Rails.configuration.accu_weather['location_key']
    end

    def get_current_conditions
        uri = URI("#{@hostname}/currentconditions/v1/#{@location_key}?apikey=#{@apikey}")
        get_response(uri)
    end    

    def get_historical_current_conditions
        uri = URI("#{@hostname}/currentconditions/v1/#{@location_key}/historical/24?apikey=#{@apikey}")
        get_response(uri)    
    end

    private

    def get_response(uri)
        response = Net::HTTP.get_response(uri)
        case response
        when Net::HTTPSuccess then
          JSON.parse(response.body)
        else
          response.value
        end
    end     
end
