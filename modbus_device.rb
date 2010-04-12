require 'rubygems'
require 'rmodbus'
require 'modbus_utility'

class ModbusDevice
  attr_accessor :port, :slave_address, :baud_rate

  def initialize (port, slave_address)
    @port = port
    @slave_address = slave_address
    @baud_rate = 9600

    #connect to rtu device
    #connect
  end

  def connected?
    if @client
      conn = !@client.closed?
    else
      conn = false
    end
    
    return conn
  end

  def connect
    @client = ModBus::RTUClient.new(@port, @baud_rate, @slave_address)
  end
  
  def disconnect
    if connected?
      @client.close
    end
    
    # confirm that device is not connected
    !connected?
  end

  def read_holding_registers (starting_reg, range, convert)
    
    if !connected?
      connect
    end
    
    # read holding registers from Modbus Slave
    data = @client.read_holding_registers(starting_reg, range)

    if convert      
      buffer = Array.new
      
      # cycle through each pair of 16bit ints to create 32bit floats
      data.each_index do |i|
        # only use even indexes
        if(i%2 == 0)
          # append combined float value to temporary array
          buffer << to_float(data[i], data[i+1])
        end
      end
      
      # overwrite array with float array
      data = buffer 
    end
  
    # disconnect from device to release lock
    disconnect
  
    # TODO: if array size =1, return value?
    return data
  end
  
end