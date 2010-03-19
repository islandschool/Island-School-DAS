#!/usr/bin/env ruby
require 'rubygems'
require 'modbus_device'

id = ARGV[0].to_i
reg = ARGV[1].to_i

dev = ModbusDevice.new('com3', id)

loop do
  begin 
    dev.slave_address = 1
    puts dev.read_holding_registers(reg, 2, true)
    
    dev.slave_address = 2
    puts dev.read_holding_registers(reg, 2, true)

	  sleep 5

  rescue Exception => e  
	  unless e.nil? 
      puts e.message  
      puts e.backtrace.inspect
    end
  end
end

