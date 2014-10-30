class ModbusController < ApplicationController

# TO-DO constants seem not working!!!!!!!

require 'rmodbus'

IP_ADDR = '192.168.1.147'
PORT = 502
ONE_BASED = true # modbus address starts in 1

before_action :get_params

  def modbus_info
    @modbus_info =  [
      { name: "red", status: 1, value: 2  }, 
      { name: "blue", status: 1, value: 2  }
      ];
    render :json => @modbus_info
  end


  def read_holding_registers 
    ModBus::TCPClient.new('192.168.1.147', 502) do |cl|
      cl.with_slave(1) do |slave|
        @registers = slave.read_holding_registers @first, @quantity
        flash[:notice] = "Successfully read registers..."
        @first += (ONE_BASED ? 1 : 0)
        render :show_modbus_read_values
      end
    end
    rescue => e
    flash[:error] = "read_holding_registers [#{@first}..#{@quantity}]: #{e}" 
    render :show_modbus_read_values
  end

  def read_coils
    ModBus::TCPClient.new(IP_ADDR, PORT) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.read_coils @first, @quantity
        flash[:notice] = "Successfully read coils..."
        @first += (ONE_BASED ? 1 : 0)
        render :show_modbus_read_values
      end
    end 
    rescue => e
    flash[:error] = "read_coils: #{e}" 
    render :show_modbus_read_values
  end

  def write_single_coil
    @first = 2 # TO-DO: relate id emergency with plc memory address
    ModBus::TCPClient.new(IP_ADDR, PORT) do |cl|
      cl.with_slave(1) do |slave|
        slave.write_single_coil @first, 1
        flash[:notice] = "Successfully closed emergency..."
        render :show_modbus_read_values
      end
    end 
    rescue => e
    flash[:error] = "write_single_coil: #{e}" 
    render :show_modbus_read_values
  end

  def write_single_register
    ModBus::TCPClient.new(IP_ADDR, PORT) do |cl|
      cl.with_slave(1) do |slave|
        slave.write_single_register @plc_id_register, @id_emergency.to_i
        flash[:notice] = "Successfully written emergency id..."
        render :show_modbus_read_values
      end
    end
    rescue => e
    flash[:error] = "write_single_register: #{e}" 
    render :show_modbus_read_values
  end

  def get_params
    @first = (params[:first] || 3) - (ONE_BASED ? 1 : 0)
    @quantity  = params[:quantity] || 6
    @id_emergency = params[:id]
    # TO-DO pending defining plc model with plc addresses
    @plc_id_register = (params[:plc_id] || 4) - (ONE_BASED ? 1 : 0)
  end
end
