require 'eeml'

class Temperature < ActiveRecord::Base
  belongs_to :reading

  #TODO: add methods to get daily, weekly, etc. averages, lows and highs

  def to_eeml
    return EEML::Data.new(value, :id => "temperature")
  end
  
end