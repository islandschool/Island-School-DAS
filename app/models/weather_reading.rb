require 'eeml'

class WeatherReading < ActiveRecord::Base
  belongs_to :reading
  delegate :created_at, :to => :reading
  
  def to_eeml_a
    return [
            EEML::Data.new(temperature, :id => "temperature"),
            EEML::Data.new(irradiance, :id => "irradiance"),
            EEML::Data.new(wind_speed, :id => "windspeed")
            ]
  end
  
end
