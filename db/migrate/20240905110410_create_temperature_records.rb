class CreateTemperatureRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :temperature_records do |t|
      t.float :value
      t.string :unit
      t.bigint :epoch_time
      t.datetime :local_observation_date_time
      t.string :location_key

      t.timestamps
    end
  end
end
