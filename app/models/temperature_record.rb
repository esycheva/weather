class TemperatureRecord < ApplicationRecord

    scope :day, -> { where('local_observation_date_time > ?', Time.now.beginning_of_day ) }

    def self.current
        day.order(:local_observation_date_time).last
    end

    def self.historical
        day.order(:local_observation_date_time)
    end

    def self.max
        day.where(value: day.maximum('value')).last
    end

    def self.min
        day.where(value: day.minimum('value')).last
    end

    def self.avg
        day.average('value')
    end

    def self.by_time
    end
end
