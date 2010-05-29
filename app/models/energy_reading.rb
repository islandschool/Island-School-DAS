require 'eeml'

class EnergyReading < ActiveRecord::Base
  belongs_to :reading
  belongs_to :source
  delegate :created_at, :to => :reading
  delegate :key, :to => :source
#  attr_accessor :local_date, :local_hour, :local_time

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
  
  def self.yesterday (source)
    tz = ActiveSupport::TimeZone.new("Eastern Time (US & Canada)")

    # TODO: do these three steps at once
    range = 1.day.ago(tz.now).beginning_of_day..1.day.ago(tz.now).end_of_day
    yestf = Reading.find(:first, :conditions => {:created_at => range})
    yestl = Reading.find(:last, :conditions => {:created_at => range})
    
    scope = yestf.id..yestl.id

    return EnergyReading.average(:power,
                                 :conditions => {:reading_id => scope, :source_id => source}
                                 ) * 24 #hack to find kWh
  end
  
  def self.now (source)
    return EnergyReading.find(:last,
                            :conditions => {:source_id => source}
                             ).power
  end
  
  def self.trailing_month (source)
    # TODO: Make less hacky
    
    query =         'SELECT AVG(er.power) * 24 AS energy,	DATE(CONVERT_TZ(r.created_at, \'UTC\', \'US/EASTERN\')) AS local_date'
    query = query + ' FROM sources s,	energy_readings er,	readings r'
    query = query + ' WHERE s.id = er.source_id AND	r.id = er.reading_id AND s.id IN (' + source.to_s + ')'
    query = query + ' GROUP BY local_date LIMIT 30'

    return EnergyReading.find_by_sql(query)

  end

  def self.trailing_month_hourly (source)
    # TODO: Make less hacky

    query = 'SELECT AVG(er.power) AS energy, DATE(CONVERT_TZ(r.created_at, \'UTC\', \'US/EASTERN\')) AS local_date, HOUR(CONVERT_TZ(r.created_at, \'UTC\', \'US/EASTERN\')) AS local_hour, MIN(CONVERT_TZ(r.created_at, \'UTC\', \'US/EASTERN\')) AS local_time'
    query = query + ' FROM sources s, energy_readings er, readings r'
    query = query + ' WHERE s.id = er.source_id AND r.id = er.reading_id AND s.id IN (' + source.to_s + ')'
    query = query + ' AND MONTH(NOW()) = MONTH(CONVERT_TZ(r.created_at, \'UTC\', \'US/EASTERN\'))'
    query = query + ' GROUP BY local_date, local_hour'    

    return EnergyReading.find_by_sql(query)

  end
  
end