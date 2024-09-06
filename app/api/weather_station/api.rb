require "grape"

module WeatherStation
    class API < Grape::API

        get :health do
            { status: 'OK' } 
        end

        namespace :weather do
            get :current do 
                TemperatureRecord.first
            end

            get :by_time do
                TemperatureRecord.limit(1) 
            end

            get :historical do 
                TemperatureRecord.limit(5)
            end 

            namespace :historical do
                get :max do 
                    TemperatureRecord.last
                end
                
                get :min do 
                    TemperatureRecord.last
                end

                get :avg do 
                    TemperatureRecord.last
                end
            end
        end
    end
end