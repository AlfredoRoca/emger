Rails.application.routes.draw do

  root 'welcome#index'

  resources :emergencies do
    collection do
      get  'places'
      post 'here_new'
    end
    member do
      post 'modbus_new_emergency'
      get  'close'
      get  'close_by_place'
    end
    resources :followups
  end

  resources :scenarios, :companies, :people

  resources :places do
    collection do
      get 'located'
    end
  end

  post   "/login",  to: "login#create"
  delete "/logout", to: "login#destroy"


  get 'modbus_read_reg', to: 'modbus#read_holding_registers'
  get 'modbus_read_coil'          , to: 'modbus#read_coils'
  get 'clear_emergency_in_plc/:id', to: 'modbus#clear_emergency_in_plc', 
    as:"clear_emergency_in_plc" 
  post 'modbus_write_reg/:id'     , to: 'modbus#write_single_register'
  get 'modbus_info'               , to: 'modbus#modbus_info'

  

  # API routes
  namespace :api do
    namespace :v1 do
      resources :emergencies, only: [:index] do
        collection do
          get  'all'
          get  'places'
        end
      end

      resources :places, only: [:index, :show] do
        collection do
          get 'pinned'
          get 'order_by_id'
        end
      end
    end
  end

end
