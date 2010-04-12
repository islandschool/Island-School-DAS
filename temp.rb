require 'rubygems'
require 'active_record'
#require 'app/models/temperature'
require 'sda_utility'
require 'eeml'
require 'modbus_device'

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/config/database.yml'))
ActiveRecord::Base.establish_connection('development')

http = Net::HTTP.new('www.pachube.com',80)
req = Net::HTTP::Put.new('/api/6286.xml', {'X-PachubeApiKey' => '3eda9134d9fc9cdde8d8977e34f522409ed713d223583f1b5de352a206e7b320'})

env = SdaUtility.new
dev = ModbusDevice.new('com3', 1)

# loop over and over again
loop do
  data = EEML::Environment.new 

  begin
    dev.slave_address = 1
    cons = dev.read_holding_registers(770, 2, true)

    dev.slave_address = 2
    prod = dev.read_holding_registers(770, 2, true)
    
    if prod[0].nan?
      prod[0] = 0
    end
    
    data << EEML::Data.new(cons[0], :id => "consumption")
    data << EEML::Data.new(prod[0], :id => "production")
  rescue Exception => e  
    unless e.nil? 
      puts e.message  
      # puts e.backtrace.inspect
    end
  end   
    
  # ensure that environmental data is reloaded  
  if env.reload
    # save data as new record
    #t = Temperature.new(:value => env["TAMB"])
    #t.save
  
    # post to pachube for archiving
    data << EEML::Data.new(env.temperature, :id => "temperature")
    data << EEML::Data.new(env.windspeed, :id => "windspeed")
    data << EEML::Data.new(env.irradiance, :id => "irradiance")
  end  

  begin
    if data
      req.body = data.to_eeml
      resp = http.request(req)
    end
  rescue Exception => e  
    unless e.nil? 
      puts e.message  
      # puts e.backtrace.inspect
    end
  end
 
  # wait for next reading 
  sleep 10
end