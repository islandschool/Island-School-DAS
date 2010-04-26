require 'eeml'

class Solar < ActiveRecord::Base
  belongs_to :reading

  def to_eeml
    return EEML::Data.new(irradiance, :id => "irradiance")
  end

end
