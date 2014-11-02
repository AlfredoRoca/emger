Rails.application.routes.draw do

  resources :emergencies do
    resources :followups
    collection do
      get  'places'     # => 'emergencies#places'
      post 'here_new'   # => 'emergencies#here_new_emergency'
    end
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
      resources :emergencies, only: [:index] do
        collection do
          get  'all'      # => 'emergencies#all'
          get  'places'   # => 'emergencies#places'
        end
      end

      resources :places, only: [:index, :show] do
        collection do
          get 'pinned'      # => 'places#pinned'
          get 'order_by_id' # => 'places#order_by_id'
        end
      end
    end
  end

end
