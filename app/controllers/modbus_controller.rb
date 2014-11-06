require 'rmodbus'

class ModbusController < ApplicationController

before_action :get_params

  def modbus_info
    # sample of return information
    # @modbus_info =  [
    #   { name: "East Arnoldostad", status: 2, value: 2, place_id: 10  }, 
    #   { name: "Jacobsmouth", status: 2, value: 2, place_id: 4  }, 
    #   { name: "Gaylefort", status: 3, value: 2, place_id: 1  }
    # ];
    read_holding_registers
    if @registers
      @modbus_info = create_hash_with_registers 
      detect_and_create_new_emergencies
    end
    render json: @modbus_info
  end

  def read_holding_registers 
    ModBus::TCPClient.new(modbus_server[:ip_addr], modbus_server[:port]) do |cl|
      cl.with_slave(1) do |slave|
        @registers = slave.read_holding_registers @first, @quantity
        flash[:notice] = "Successfully read registers..."
        # @first += (modbus_server[:one_based_addressing] ? 1 : 0)
        # render :show_modbus_read_values
      end
    end
    rescue => e
    flash[:error] = "read_holding_registers [#{@first}..#{@quantity}]: #{e}" 
    # render :show_modbus_read_values
  end

  def create_hash_with_registers
    # the expected sequence of integer registers is
    # status, analog value, boolean condition, place_id
    # this function return an array of hashes (see sample in modbus_info)

    # simulation without plc for 4 places
    #@registers = %w{ 1 45 1 5 1 67 0 6 0 234 0 7 0 999 1 9 }
    
    result = []
    until @registers.empty? do
      plc_zone = @registers.slice!(0,4)
      place_name = Place.find(plc_zone[3])
      result << { name: Place.find(plc_zone[3]).name, status: plc_zone[0], value: plc_zone[1], condition: plc_zone[2], place_id: plc_zone[3] }
    end
    result
  rescue ActiveRecord::RecordNotFound
    result
  end

  def detect_and_create_new_emergencies
    until @registers.empty? do
      plc_zone = @registers.slice!(0,4)
      status    = plc_zone[0]
      value     = plc_zone[1]
      condition = plc_zone[2]
      place_id  = plc_zone[3]
      unless place_id == 0
        if status == modbus_server[:value_for_emergency]
          unless Emergency.open.find_by place_id: place_id
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
  end

  def read_coils
    ModBus::TCPClient.new(modbus_server[:ip_addr], modbus_server[:port]) do |cl|
      cl.with_slave(1) do |slave|
        @coils = slave.read_coils @first, @quantity
        flash[:notice] = "Successfully read coils..."
        @first += (modbus_server[:one_based_addressing] ? 1 : 0)
        render :show_modbus_read_values
      end
    end 
    rescue => e
    flash[:error] = "read_coils: #{e}" 
    render :show_modbus_read_values
  end

  def clear_emergency_in_plc
    first = list_of_places.index(params[:id].to_i)
    unless first.nil?
      ModBus::TCPClient.new(modbus_server[:ip_addr], modbus_server[:port]) do |cl|
        cl.with_slave(1) do |slave|
          slave.write_single_coil first, 1
          flash[:notice] = "Successfully closed emergency in PLC..."
          response = { "success" => "Successfully closed emergency in PLC..." }
          # render json: response
          redirect_to emergencies_url
        end
      end 
    end
    rescue => e
    flash[:error] = "write_single_coil: #{e}" 
    response = { "error" => "write_single_coil error..." }
    render json: response
    # redirect_to emergencies_url
  end

  def write_single_register
    ModBus::TCPClient.new(modbus_server[:ip_addr], modbus_server[:port]) do |cl|
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
    @first = (params[:first] || 1) - (modbus_server[:one_based_addressing] ? 1 : 0)
    @quantity  = params[:quantity] || 16
    @id_emergency = params[:id]
    @plc_id_register = (params[:plc_id] || 4) - (modbus_server[:one_based_addressing] ? 1 : 0)
  end

  def modbus_server
    Rails.application.config.modbus_server
  end
  def list_of_places
    Rails.application.config.modbus_list_of_places
  end
end
