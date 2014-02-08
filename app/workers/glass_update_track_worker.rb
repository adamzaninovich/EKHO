class GlassUpdateTrackWorker
  include Sidekiq::Worker
  #include Sidetiq::Schedulable

  sidekiq_options retry: false

  #recurrence do
  #  minutely.second_of_minute 0, 15, 30, 45
  #end

  def device_id
    'living-room'
  end

  def perform
    User.all.each do |user|
      track = TrackUpdate.find_or_init_with user_id: user.id, device_id: device_id
      unless track.persisted?
        track.persisted? ? track.touch : track.save
        api = user.get_mirror_api_client
        add_card api, track.title, track.artist
      end
    end
  end

  def add_card api, title, artist
    card = {
      bundle_id: "ekho_tracks:#{device_id}",
      notification: {level:"DEFAULT"},
      menu_items: [
        {
          action:"CUSTOM",
          id:"#{device_id}:pause",
          values:[{
            iconUrl: "http://weepingangel.no-ip.info:8000/assets/menu_icons/ic_music_pause_50.png",
            displayName:"Pause Track"
          }]
        },
        {
          action:"CUSTOM",
          id:"#{device_id}:play",
          values:[{
            iconUrl: "http://weepingangel.no-ip.info:8000/assets/menu_icons/ic_music_play_50.png",
            displayName:"Play Track"
          }]
        },
        {
          action:"CUSTOM",
          id:"#{device_id}:next",
          values:[{
            iconUrl: "http://weepingangel.no-ip.info:8000/assets/menu_icons/ic_music_next_50.png",
            displayName:"Next Track"
          }]
        },
        {
          action:"CUSTOM",
          id:"#{device_id}:previous",
          values:[{
            iconUrl: "http://weepingangel.no-ip.info:8000/assets/menu_icons/ic_music_previous_50.png",
            displayName:"Previous Track"
          }]
        },
        {action:"READ_ALOUD"},
        {action:"DELETE"}
      ],
      text: "The current song in the #{device_id.underscore.humanize} is #{title} by #{artist} - Powered by echo.",
      html: "<article><section><h1 class=\"text-auto-size blue\">#{title}</h1><h2 class=\"muted\">#{artist}</h2></section><footer><div>powered by <span class=\"red\">EKHO</span></div></footer></article>"
    }
    api.timeline.insert card
  end

end
