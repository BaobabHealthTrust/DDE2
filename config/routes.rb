Rails.application.routes.draw do
  root 'administration#index'
  
  get "check_thresholds" => "services#check_thresholds"
  
  get "process_queued_sites" => "services#process_queued_sites"
  
  get 'administration/site_add'

  get 'administration/site_edit'

  get 'administration/site_show'

  get 'administration/region_add'

  get 'administration/region_edit'

  get 'administration/region_show'

  get 'administration/user_add'

  get 'administration/user_edit'

  get 'administration/user_show'

  get 'administration/master_people'

  get 'administration/proxy_people'

  get 'administration/index'

  resources :people do
    collection do
      post :create, :update, :destroy
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
