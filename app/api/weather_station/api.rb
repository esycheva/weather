require "grape"

module WeatherStation
    class API < Grape::API

        get :health do
            { status: 'OK' } 
        end

        namespace :weather do
            get :current do 
                TemperatureRecord.current
            end

            get :by_time do
                TemperatureRecord.by_time 
            end

            get :historical do 
                TemperatureRecord.historical
            end 

            namespace :historical do
                get :max do 
                    TemperatureRecord.max
                end
                
                get :min do 
                    TemperatureRecord.min
                end

                get :avg do 
                    TemperatureRecord.avg
                end
            end
        end
    end
end