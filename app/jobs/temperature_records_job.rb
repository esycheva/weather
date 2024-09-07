class TemperatureRecordsJob < ApplicationJob
    queue_as :default

    # Из консоли Rails приложения можно выполнить:
    #   -  TemperatureRecordsJob.perform_now
    #   -  TemperatureRecordsJob.perform_later
    def perform
        service = AccuWeatherService.new
        service.save_historical_current_conditions
        puts "I'm getting new temperature records from the AccuWeatherAPI"
    end
end