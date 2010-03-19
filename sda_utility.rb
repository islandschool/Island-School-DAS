require 'rubygems'
require 'httparty'

class SdaUtility
  attr_accessor :temperature, :irradiance, :windspeed,
                :power, :daily_energy, :yearly_energy, :yearly_carbon
  
  def initialize
    @data = HTTParty.get('http://192.168.1.202/data/CAPE01-RTD.xml')
    
    if success?
      @data = @data["DAS"]
      @temperature = @data["TAMB"]
      @irradiance = @data["IRRAD"]
      @windspeed = @data["WS"]
      @power = @data["KWINV0"]
      @daily_energy = @data["DKWHINV0"]
      @yearly_energy = @data["YKWHTOT0"]
      @yearly_carbon = @data["YCO2"]
    end
  end
  
  def success?
    !@data.nil?
  end
  
  def reload
    initialize
    return success?
  end
  
end