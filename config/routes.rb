Ekho::Application.routes.draw do

  # Auth
  get 'auth/:provider/callback' => 'sessions#create'
  get 'auth/failure' => redirect('/')
  match 'sessions/destroy', as: :sign_out, via: [:get, :delete]

  resources :devices
  root 'devices#index'

  post '/sms/control' => 'sms#control'
  post '/sms/play' => 'sms#control'

  get  '/devices/:id/now_playing'            => 'devices#now_playing', as: 'now_playing', format: :js
  post '/devices/:id/control/song/previous'  => 'devices#previous',    as: 'previous_song'
  post '/devices/:id/control/song/pause'     => 'devices#pause',       as: 'pause_song'
  post '/devices/:id/control/song/play'      => 'devices#play',        as: 'play_song'
  post '/devices/:id/control/song/next'      => 'devices#next',        as: 'next_song'
  post '/devices/:id/control/volume/down'    => 'devices#vol_down',    as: 'volume_down'
  post '/devices/:id/control/volume/up'      => 'devices#vol_up',      as: 'volume_up'

end
