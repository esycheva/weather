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

    def self.by_time(seconds)
        min_distance_id = self.min_distance_id(seconds)
        TemperatureRecord.find(min_distance_id)
    end

    def self.min_distance(seconds)
        str = "SELECT MIN(ABS(epoch_time - #{seconds})) as min_distance FROM temperature_records"
        results = connection.select_all(str)

        if results.present?
            return results[0]['min_distance']
        else
            return nil
        end
    end

    def self.min_distance_id(seconds, min)
        dt = Time.at(seconds)
        sql = <<-SQL
            SELECT id,
                   CASE WHEN ABS(epoch_time - #{seconds}) = #{min} THEN 1
                   ELSE 0
                   END
            FROM temperature_records
            WHERE temperature_records.local_observation_date_time
                  BETWEEN '#{dt - 24.hours}' AND '#{dt + 24.hours}';
        SQL
        results = connection.select_all(sql)

        if results.present?
            return results.detect{|i| i['case'] == 1}['id']
        else
            return nil
        end
    end
end
