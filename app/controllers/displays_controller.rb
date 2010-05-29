# require 'googlecharts'

class DisplaysController < ApplicationController
  def orb
    cons = EnergyReading.yesterday(1)
    prod = EnergyReading.yesterday(2)
    @today = Date.today
    
    @consumption = cons.round(1).to_s
    @production = prod.round(1).to_s
        
    @red = 0
    @green = 0
    @blue = 0
    
    @red = case cons
      when 0..2.99 then 0
      when 3..6.99 then 100
      when 7..9.99 then 200
      else 300
    end
    
    @green = case prod
      when 0..4.99 then 0
      when 5..14.99 then 100
      when 15..21.99 then 200
      else 0
    end

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