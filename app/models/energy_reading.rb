require 'eeml'

class EnergyReading < ActiveRecord::Base
  belongs_to :reading
  belongs_to :source
  delegate :created_at, :to => :reading
  delegate :key, :to => :source

  # just return power as default eeml
  def to_eeml
    return EEML::Data.new(power, :id => key)
  end
  
  # return extended eeml array
  def to_eeml_a
    return [
            EEML::Data.new(power, :id => key),
            EEML::Data.new(frequency, :id => "frequency"),
            EEML::Data.new(voltage, :id => "voltage"),
            EEML::Data.new(energy, :id => "energy")
            ]
  end
end