require 'rubygems'
require 'bindata'

def to_float (int1,int2)
  # convert each int16 to binary string
  a = to_bin_s(int1)
  b = to_bin_s(int2)

  # combine and return as a float
  prod = BinData::FloatBe.read(a+b)
  
  if prod.nan?
      prod = 0
  end
  
  return prod
end

def to_bin_s (hex)
  a = BinData::Int16be.new
  a.value = hex
  return a.to_binary_s
end