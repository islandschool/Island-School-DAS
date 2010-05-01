class CreateWeatherReadings < ActiveRecord::Migration
  def self.up
    create_table :weather_readings do |t|
      t.float :temperature
      t.float :irradiance
      t.float :wind_speed
      t.float :wind_direction
      t.references :reading
    end
  end

  def self.down
    drop_table :weather_readings
  end
end
