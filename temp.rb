require 'rubygems'
require 'active_record'
require 'config/environment'
require 'sda_utility'
require 'eeml'
require 'modbus_device'

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/config/database.yml'))
ActiveRecord::Base.establish_connection('development')

http = Net::HTTP.new('www.pachube.com',80)
req = Net::HTTP::Put.new('/api/6286.xml', {'X-PachubeApiKey' => '3eda9134d9fc9cdde8d8977e34f522409ed713d223583f1b5de352a206e7b320'})

env = SdaUtility.new

save = true

# loop over and over again
loop do
  data = EEML::Environment.new
  
  begin
    r = Reading.new
    save = r.save
  rescue Exception => e  
    unless e.nil? 
      puts e.message  
    end
  end 

  begin
    # set to transducer for main interconnection  
    dev = ModbusDevice.new
    
    # PT 1 = IS ATS
    pt1 = dev.read('com3', 1, 784, 70)

    # PT 2 = IS RE
    pt2 = dev.read('com3', 2, 784, 70)
    
    # PT 3 = IS Wind + BH load leg 1
    pt3 = dev.read('com4', 3, 784, 70)

    # PT 4 = IS BH PV + BH load leg 2
    pt4 = dev.read('com4', 4, 784, 70)
    
    # TODO: add other transducers
    
    # close modbus connection after all readings
    dev = nil
    
    # generate EnergyReading objects for data collected
    # TODO: use enumerable instead of straight source ids
    
    # CEI Solar Array
    cei_pv = EnergyReading.new(:power => env.power,
                               :energy => env.daily_energy,
                               :reading_id => r.id,
                               :source_id => 4)
    cei_pv.save unless !save
    
    # CEI Total RE Production (just solar for now)
    cei_re = EnergyReading.new(:power => env.power,
                               :energy => env.daily_energy,
                               :reading_id => r.id,
                               :source_id => 3)
    cei_re.save unless !save
    
    
    # IS Total RE Production
    is_re = EnergyReading.new(:frequency => pt2[0],
                              :voltage => pt2[2],
                              :voltage_a => pt2[2],
                              :voltage_b => pt2[3],
                              :current => pt2[8]+pt2[9],
                              :current_a => pt2[8],
                              :current_b => pt2[9],
                              :power => pt2[11]+pt2[12],
                              :power_a => pt2[11],
                              :power_b => pt2[12],
                              :energy => pt2[32]+pt2[33],
                              :energy_a => pt2[32],
                              :energy_b => pt2[33],
                              :reading_id => r.id,
                              :source_id => 2)
    is_re.save unless !save
    
    is_con = EnergyReading.new(:frequency => pt1[0],
                              :voltage => pt1[2],
                              :voltage_a => pt1[2],
                              :voltage_b => pt1[3]+pt1[4],
                              :current => pt1[8]+pt1[9]+pt1[10],
                              :current_a => pt1[8],
                              :current_b => pt1[9]+pt1[10],
                              :power => pt1[11]+pt1[12]+pt1[13],
                              :power_a => pt1[11],
                              :power_b => pt1[12]+pt1[13],
                              :energy => pt1[32]+pt1[33]+pt1[34],
                              :energy_a => pt1[32],
                              :energy_b => pt1[33]+pt1[34],
                              :reading_id => r.id,
                              :source_id => 1)
    is_con.save unless !save
    
    # special case -- only two of three legs are active, either BEC or generator
    genset = (pt1[10] > 0)
    is_gen = nil
    is_bec = nil
    
    if genset
      # no RE, just generator
      is_gen = EnergyReading.new(:frequency => pt1[0],
                              :voltage => pt1[2],
                              :voltage_a => pt1[2],
                              :voltage_b => pt1[4],
                              :current => pt1[8]+pt1[10],
                              :current_a => pt1[8],
                              :current_b => pt1[10],
                              :power => pt1[11]+pt1[13],
                              :power_a => pt1[11],
                              :power_b => pt1[13],
                              :energy => pt1[32]+pt1[34],
                              :energy_a => pt1[32],
                              :energy_b => pt1[34],
                              :reading_id => r.id,
                              :source_id => 8)
      is_gen.save unless !save
    else
      # BEC = Load - RE
      # TODO: verify that this is legit
      is_bec = EnergyReading.new(:frequency => pt1[0],
                              :voltage => pt1[2],
                              :voltage_a => pt1[2],
                              :voltage_b => pt1[3],
                              :current => pt1[8]+pt1[9]-pt2[8]-pt2[9],
                              :current_a => pt1[8]-pt2[8],
                              :current_b => pt1[9]-pt2[9],
                              :power => pt1[11]+pt1[12]-pt2[11]-pt2[12],
                              :power_a => pt1[11]-pt2[11],
                              :power_b => pt1[12]-pt2[12],
                              :energy => pt1[32]+pt1[33]-pt2[32]-pt2[33],
                              :energy_a => pt1[32]-pt2[32],
                              :energy_b => pt1[33]-pt2[33],
                              :reading_id => r.id,
                              :source_id => 9)
      is_bec.save unless !save
    end

    # IS Wind Production
    is_gt = EnergyReading.new(:frequency => pt3[0],
                              :voltage => pt3[2],
                              :voltage_a => pt3[2],
                              :voltage_b => pt3[3],
                              :current => pt3[8]+pt3[9],
                              :current_a => pt3[8],
                              :current_b => pt3[9],
                              :power => pt3[11]+pt3[12],
                              :power_a => pt3[11],
                              :power_b => pt3[12],
                              :energy => pt3[32]+pt3[33],
                              :energy_a => pt3[32],
                              :energy_b => pt3[33],
                              :reading_id => r.id,
                              :source_id => 5)
    is_gt.save unless !save

    # IS Boathouse PV Production (broken atm -- issue w/ power reading being negative/NaN)
    is_bhpv = EnergyReading.new(:frequency => pt4[0],
                              :voltage => pt4[2],
                              :voltage_a => pt4[2],
                              :voltage_b => pt4[3],
                              :current => pt4[8]+pt4[9],
                              :current_a => pt4[8],
                              :current_b => pt4[9],
                              :power => pt4[11]+pt4[12],
                              :power_a => pt4[11],
                              :power_b => pt4[12],
                              :energy => pt4[32]+pt4[33],
                              :energy_a => pt4[32],
                              :energy_b => pt4[33],
                              :reading_id => r.id,
                              :source_id => 6)
    is_bhpv.save unless !save

    # IS Boathouse loads - across PT3 and PT4
    is_bhld = EnergyReading.new(:frequency => pt3[0],
                              :voltage => pt3[4],
                              :voltage_a => pt3[4],
                              :voltage_b => pt4[4],
                              :current => pt3[10]+pt4[10],
                              :current_a => pt3[10],
                              :current_b => pt4[10],
                              :power => pt3[13]+pt4[13],
                              :power_a => pt3[13],
                              :power_b => pt4[13],
                              :energy => pt3[34]+pt4[34],
                              :energy_a => pt3[34],
                              :energy_b => pt4[34],
                              :reading_id => r.id,
                              :source_id => 7)
    is_bhld.save unless !save

    # now that all data is stored and saved, add to EEML data for pachube
    
    
    # full set from IS ATS
    is_con.to_eeml_a.each do |datum|
        data << datum
    end

    data << is_re.to_eeml
    data << is_gt.to_eeml
    data << cei_re.to_eeml

    if is_bec.nil?
      data << EEML::Data.new(0.0, :id => "is-bec")
    else  
      data << is_bec.to_eeml unless is_bec.nil?
    end
    
    if is_gen.nil?
      data << EEML::Data.new(0.0, :id => "is-generator")
    else
      data << is_gen.to_eeml
    end
      
  rescue Exception => e  
    unless e.nil? 
      puts e.message
      puts e.backtrace
    end
  end   
    
  # ensure that environmental data is reloaded  
  if env.reload
    
    begin
      # create models and save
      w = WeatherReading.new(:temperature => env.temperature,
                             :irradiance => env.irradiance, 
                             :wind_speed => env.windspeed,
                             :reading_id => r.id)
      w.save unless !save
    
      # add to eeml for archiving
      w.to_eeml_a.each do |datum|
        data << datum
      end
    rescue Exception => e  
      unless e.nil? 
        puts e.message  
        # puts e.backtrace.inspect
      end
    end
  end
  
  begin
    if data
      req.body = data.to_eeml
      resp = http.request(req)
      #puts resp
    end
  rescue Exception => e  
    unless e.nil? 
      puts e.message  
      # puts e.backtrace.inspect
    end
  end
 
  # wait for next reading 
  sleep 8
end