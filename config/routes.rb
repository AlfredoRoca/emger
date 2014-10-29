Rails.application.routes.draw do

  resources :emergencies, :scenarios, :companies, :places, :people, :followups

  root 'login#new'

  get 'emergency_close/:id' => 'emergencies#close', as: :close_emergency
  get 'modbus_read_reg' => 'modbus#read_holding_registers'
  get 'modbus_read_coil' => 'modbus#read_coils'
  post 'modbus_write_coil/:id' => 'modbus#write_single_coil', as: :write_clear_in_plc
  post 'modbus_write_reg/:id' => 'modbus#write_single_register', as: :write_id_in_plc

  post   "/login",  to: "login#create"
  delete "/logout", to: "login#destroy"

  get 'pinned_places' => 'places#load_pinned_places'

end
