Rails.application.routes.draw do
  post 'user/create'

  post 'user/edit'

  get 'user/username_availability'

  get 'user/view'

  get 'user/new'

  get 'user/settings'

  get 'user/login'

  post 'user/login'

  get 'user/logout'

  root 'administration#index'
  
  get "check_thresholds" => "services#check_thresholds"
  
  get "process_queued_sites" => "services#process_queued_sites"
  
  get 'administration/site_add'

  post 'administration/create_site'

  get 'administration/site_edit'

  post 'administration/update_site'

  get 'administration/site_show'

  get 'administration/site_assign'

  get 'administration/region_edit'

  get 'administration/region_show'

  get 'administration/index'
  
  post 'check_site_code' => "services#check_site_code"

  get '/map' => "administration#map"
  
  get '/national_map' => "administration#national_map"
  
  get '/sync_map' => "administration#sync_map"
  
  get '/region/:id' => "administration#regional_map"
  
  get "/search_by_site_code/:id" => "services#search_by_site_code"

  post "/assign_npids_to_region" => "administration#assign_npids_to_region"

  post "/assign_npids_to_site" => "administration#assign_npids_to_site"

  get "/check_region_allocation" => "services#check_region_allocation"

  get "/check_site_allocation" => "services#check_site_allocation"

  get "/search_for_patients_by_site" => "services#search_for_patients_by_site"

  get 'administration/connection_add'

  get 'administration/connection_edit'

  get 'administration/connection_show'
  
  post 'administration/connection_create'

  post 'administration/connection_update'

  get '/check_duplicate_connections' => "services#check_duplicate_connections"

  resources :people do
    collection do
      post :find,:create, :update,:create_footprint
      get :index, :new, :show, :edit, :confirm_demographics
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.                              z
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
