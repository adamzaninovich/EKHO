Ekho::Application.routes.draw do

  resources :devices
  root 'devices#index'

  get  '/devices/:id/now_playing'            => 'devices#now_playing', as: 'now_playing', format: :js
  post '/devices/:id/control/song/previous'  => 'devices#previous',    as: 'previous_song'
  post '/devices/:id/control/song/pause'     => 'devices#pause',       as: 'pause_song'
  post '/devices/:id/control/song/play'      => 'devices#play',        as: 'play_song'
  post '/devices/:id/control/song/next'      => 'devices#next',        as: 'next_song'
  post '/devices/:id/control/volume/down'    => 'devices#vol_down',    as: 'volume_down'
  post '/devices/:id/control/volume/up'      => 'devices#vol_up',      as: 'volume_up'

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
