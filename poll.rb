#!/usr/bin/env ruby

require 'rubygems'
require 'rmodbus'
require 'bindata'

id = ARGV[0].to_i
reg = ARGV[1].to_i

cl = ModBus::RTUClient.new('com3', 9600, id)
data = cl.read_holding_registers(reg, 2)

a = BinData::Int16be.new
a.value = data[0]
a.to_binary_s

b = BinData::Int16be.new
b.value = data[0]
b.to_binary_s

fl = BinData::FloatBe.read(a.to_binary_s+b.to_binary_s)

puts fl.to_s