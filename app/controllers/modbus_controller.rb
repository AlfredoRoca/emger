require 'rmodbus'

class ModbusController < ApplicationController

before_action :get_params

  def modbus_info
    # sample 
    # @modbus_info =  [
    #   { name: "East Arnoldostad", status: 2, value: 2  }, 
    #   { name: "Jacobsmouth", status: 2, value: 2  }, 
    #   { name: "Gaylefort", status: 3, value: 2  }
    # ];
    @modbus_info = create_hash_with_registers
    render :json => @modbus_info
  end

  def create_hash_with_registers
    # the expected sequence of registers is, by place
    # status, analog value, boolean condition, place_id
    # this function return an array of hashes

    # simulation without plc for 3 places
    @registers = %w{ 1 45 1 4 1 67 0 2 0 234 0 10 1 999 1 5 }
    
    result = []
    until @registers.empty? do
      set = @registers.slice!(0,4)
      result << { name: Place.find(set[3]).name, status: set[0], value: set[1], condition: set[2], place_id: set[3] }
    end
    return result
  end

  def read_holding_registers 
    ModBus::TCPClient.new(MODBUS_SERVER_IP_ADDR, MODBUS_SERVER_PORT) do |cl|
      cl.with_slave(1) do |slave|
        @registers = slave.read_holding_registers @first, @quantity
        flash[:notice] = "Successfully read registers..."
        @first += (MODBUS_SERVER_ONE_BASED_ADDRESSING ? 1 : 0)
        detect_and_create_new_emergencies
        # render :show_modbus_read_values
      end
    end
    rescue => e
    flash[:error] = "read_holding_registers [#{@first}..#{@quantity}]: #{e}" 
    render :show_modbus_read_values
  end

  def detect_and_create_new_emergencies
    modbus_registers = @registers
    until @modbus_registers.empty? do
      set = @modbus_registers.slice!(0,4)
      status    = set[0]
      value     = set[1]
      condition = set[2]
      place_id  = set[3]
      # emergency if MODBUS_SERVER_VALUE_FOR_EMERGENCY
      if status == MODBUS_SERVER_VALUE_FOR_EMERGENCY
        # check if there is any emergency open in the same place
        unless Emergency.open.find(place_id)
          # create a new emergency
          emergency = Emergency.create(
            date: DateTime::now, 
            status: Emergency::EMERGENCY_STATUS_OPEN,
            simulacrum: false,
            place_id: place_id)
          emergency.save
          # TODO check errors
        end
      end
    end

  end

  def read_coils
    ModBus::TCPClient.new(MODBUS_SERVER_IP_ADDR, MODBUS_SERVER_PORT) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.read_coils @first, @quantity
        flash[:notice] = "Successfully read coils..."
        @first += (MODBUS_SERVER_ONE_BASED_ADDRESSING ? 1 : 0)
        render :show_modbus_read_values
      end
    end 
    rescue => e
    flash[:error] = "read_coils: #{e}" 
    render :show_modbus_read_values
  end

  def write_single_coil
    @first = 2 # TO-DO: relate id emergency with plc memory address
    ModBus::TCPClient.new(MODBUS_SERVER_IP_ADDR, MODBUS_SERVER_PORT) do |cl|
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
    ModBus::TCPClient.new(MODBUS_SERVER_IP_ADDR, MODBUS_SERVER_PORT) do |cl|
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
    @first = (params[:first] || 3) - (MODBUS_SERVER_ONE_BASED_ADDRESSING ? 1 : 0)
    @quantity  = params[:quantity] || 6
    @id_emergency = params[:id]
    # TO-DO pending defining plc model with plc addresses
    @plc_id_register = (params[:plc_id] || 4) - (MODBUS_SERVER_ONE_BASED_ADDRESSING ? 1 : 0)
  end
end
