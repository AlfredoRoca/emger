class ModbusController < ApplicationController
IP_ADDR = '192.168.1.147'
PORT = 502

# TO-DO constants seem not working!!!!!!!

require 'rmodbus'

before_action :get_params

  def read_holding_registers 
    ModBus::TCPClient.connect('192.168.1.147', 502) do |cl|
      cl.with_slave(1) do |slave|
        @registers = slave.holding_registers[@first..@last]
        render :show_modbus_read_values
      end
    end
    # rescue => e
    #   render text: "Error: #{e}" 
  end

  def read_coils
    ModBus::TCPClient.connect('192.168.1.147', 502) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.read_coils @first, @last
        render :show_modbus_read_values
      end
    end 
  end

  def write_coil
    @first = 2 # TO-DO: relate id emergency with plc memory address
    ModBus::TCPClient.connect('192.168.1.147', 502) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.write_coil @first, 1
        render :show_modbus_read_values
      end
    end 
  end

  def get_params
    @first = params[:first]
    @last  = params[:last]
    @id_emergency = params[:id]
  end
end
