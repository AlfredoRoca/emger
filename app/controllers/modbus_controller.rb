class ModbusController < ApplicationController
IP_ADDR = '192.168.1.147'
PORT = 502

require 'rmodbus'

  def read_holding_registers
    ModBus::TCPClient.connect('192.168.1.147', 502) do |cl|
      cl.with_slave(1) do |slave|
        @registers = slave.holding_registers[0..14]
        render :show_modbus_read_values
      end
    end
    # rescue => e
    #   render text: "Error: #{e}" 
  end

  def read_coils
    ModBus::TCPClient.connect(IP_ADDR, PORT) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.read_coils 0, 10
        render :show_modbus_read_values
      end
    end 
  end

end
