Rails.application.routes.draw do

resources :emergencies, :scenarios, :companies, :places, :people

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
root 'emergencies#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
get 'emergency_close/:id' => 'emergencies#close', as: :close_emergency
get 'modbus_read_reg' => 'modbus#read_holding_registers'
get 'modbus_read_coil' => 'modbus#read_coils'
post 'modbus_write_coil/:id' => 'modbus#write_single_coil', as: :write_clear_in_plc
post 'modbus_write_reg/:id' => 'modbus#write_single_register', as: :write_id_in_plc

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
