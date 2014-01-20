require 'sidekiq/web'
require 'sidetiq/web'
Ekho::Application.routes.draw do

  # Auth
  get   'auth/:provider/callback' => 'sessions#create'
  get   'auth/failure' => redirect('/')
  match 'sessions/destroy', as: :sign_out, via: [:get, :delete]

  resources :devices
  root 'devices#index'

  post 'glass/location_update'
  post 'glass/control'

  post 'sms/control'
  post 'sms/play'

  get  'devices/:id/glass_update_track'     => 'devices#glass_update_track', as: 'glass_update_track', format: :js
  get  'devices/:id/now_playing'            => 'devices#now_playing', as: 'now_playing', format: :js
  post 'devices/:id/control/song/previous'  => 'devices#previous',    as: 'previous_song'
  post 'devices/:id/control/song/pause'     => 'devices#pause',       as: 'pause_song'
  post 'devices/:id/control/song/play'      => 'devices#play',        as: 'play_song'
  post 'devices/:id/control/song/next'      => 'devices#next',        as: 'next_song'
  post 'devices/:id/control/volume/down'    => 'devices#vol_down',    as: 'volume_down'
  post 'devices/:id/control/volume/up'      => 'devices#vol_up',      as: 'volume_up'

  mount Sidekiq::Web, at: '/sidekiq'

end
