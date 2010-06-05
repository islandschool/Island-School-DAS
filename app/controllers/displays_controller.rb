# require 'googlecharts'
include DisplaysHelper

class DisplaysController < ApplicationController
  
  def index
     @cons_yst = EnergyReading.yesterday(1).round(2).to_s
     @prod_yst = EnergyReading.yesterday(2).round(2).to_s
     @cons_now = EnergyReading.now(1).round(2).to_s
     @prod_now = EnergyReading.now(2).round(2).to_s
  end
  
  def research
  end
  
  def results
  end
  
  def orb
    cons_yest = EnergyReading.yesterday(1)
    prod_yest = EnergyReading.yesterday(2)

    cons_now = EnergyReading.now(1)
    prod_now = EnergyReading.now(2)
    
    @used_yest = cons_yest.round(1).to_s
    @made_yest = prod_yest.round(1).to_s
    
    @used_now = cons_now.round(2).to_s
    @make_now = prod_now.round(2).to_s
        
    colors = to_colors(cons_now, prod_now, cons_yest, prod_yest)

    @red = colors['red']
    @green = colors['green']
    @blue = colors['blue']
    
    weather = WeatherReading.find(:last)
    @wspd = weather.wind_speed.round(1)
    @temp = weather.temperature.to_int
    @irrd = weather.irradiance.to_int
    
  end
  
  def yesterday
    @consumption = EnergyReading.yesterday(1).round(2).to_s
    @production = EnergyReading.yesterday(2).round(2).to_s
  end
  
  def now
    @consumption = EnergyReading.now(1).round(2).to_s
    @production = EnergyReading.now(2).round(2).to_s
  end
  
  def timeline
    
    hourly = params[:detail] == 'hourly'    
    
    if hourly
      cons = EnergyReading.trailing_month_hourly(1)
      prod = EnergyReading.trailing_month_hourly(2)
    else
      cons = EnergyReading.trailing_month(1)
      prod = EnergyReading.trailing_month(2)
    end
    
    @data = {}
    
    if hourly
      cons.each_index do |i|
        @data[DateTime.strptime(cons[i].local_time, "%Y-%m-%d %H:%M:%S").to_time] = 
              {:consumption => cons[i].energy, :production =>  prod[i].energy }
      end
      
    else 
      cons.each_index do |i|
        @data[Date.strptime(cons[i].local_date, "%Y-%m-%d")] = 
              {:consumption => cons[i].energy, :production =>  prod[i].energy }
      end
      
    end
  end
  
end