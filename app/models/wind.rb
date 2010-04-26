require 'eeml'

class Wind < ActiveRecord::Base
  belongs_to :reading

  # TODO: update to allow for passing speed and directions
  def to_eeml
    return EEML::Data.new(speed, :id => "windspeed")
  end

end