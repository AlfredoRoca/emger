Rails.application.routes.draw do

  root 'emergencies#index'

  resources :emergencies do
    collection do
      get  'places'     # => 'emergencies#places'
      post 'here_new'   # => 'emergencies#here_new_emergency'
    end
    member do
      post 'modbus_new_emergency'   # => 'emergencies#modbus_new_emergency'
      get  'close'                  # => 'emergencies#close', as: :close_emergency
      get  'close_by_place'         # => 'emergencies#close_by_place'
    end
    resources :followups
  end

  resources :scenarios, :companies, :people

  resources :places do
    collection do
      get 'located'          # => 'places#pinned_places'
    end
  end

  post   "/login",  to: "login#create"
  delete "/logout", to: "login#destroy"


  get 'modbus_read_reg'         => 'modbus#read_holding_registers'
  get 'modbus_read_coil'        => 'modbus#read_coils'
  get 'modbus_write_coil/:id'  => 'modbus#write_single_coil', as: :write_clear_in_plc
  post 'modbus_write_reg/:id'   => 'modbus#write_single_register', as: :write_id_in_plc
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
