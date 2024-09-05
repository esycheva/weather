#! /usr/bin/env ruby

# accu_weather_service.rb - сервис для работы с AccuWeather 

class AccuWeatherService
    attr_reader :client

    def initialize
        @client = AccuWeatherClient.new
    end
    
    def save_current_conditions
        save(client.get_current_conditions)                
    rescue StandardError => e
        Rails.logger.info 'Error during temperature saving'
        Rails.logger.info e.message
        Rails.logger.info e.backtrace[0, 10].join("\n")
        []
    end

    def save_historical_current_conditions
        save(client.get_historical_current_conditions)
    rescue StandardError => e
        Rails.logger.info 'Error during temperature saving'
        Rails.logger.info e.message
        Rails.logger.info e.backtrace[0,10].join("\n")
        []
    end

    private 
    
    def save(conditions)
        conditions.map do |condition|
            metric = condition['Temperature'] && condition['Temperature']['Metric']

            unless metric && metric['Value']
                raise 'Temperature value not found in metrics'
            end
            TemperatureRecord.find_or_create_by(epoch_time: condition['EpochTime']) do |condition|
                condition.value = metric['Value']
                condition.unit = metric['Unit']
                condition.location_key = condition['LocationKey']
                condition.local_observation_date_time = condition['LocalObservationDateTime']
            end
        end
    end    
end
