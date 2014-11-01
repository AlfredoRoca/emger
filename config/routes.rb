Rails.application.routes.draw do

  resources :emergencies do
    resources :followups
  end
  resources :scenarios, :companies, :places, :people

  root 'emergencies#index'

  post   "/login",  to: "login#create"
  delete "/logout", to: "login#destroy"

  get 'emergency_close/:id'     => 'emergencies#close', as: :close_emergency

  get 'modbus_read_reg'         => 'modbus#read_holding_registers'
  get 'modbus_read_coil'        => 'modbus#read_coils'
  post 'modbus_write_coil/:id'  => 'modbus#write_single_coil', as: :write_clear_in_plc
  post 'modbus_write_reg/:id'   => 'modbus#write_single_register', as: :write_id_in_plc

  get 'pinned_places'           => 'places#load_pinned_places'
  get 'place/:place_id'         => 'places#send_place'
  
  get 'modbus_info'             => 'modbus#modbus_info'

  # API routes
  namespace :api do
    namespace :v1 do
      resources :emergencies, only: [:index]
      get  'emergencies/all'    => 'emergencies#index_all'
      post 'herenew'            => 'emergencies#here'
    end
  end

end
