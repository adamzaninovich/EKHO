class GlassLocationWorker
  include Sidekiq::Worker

  def perform user_id
    #get location
    #if location is outside of radius
    #  pause music
    #  send notification
    #end
  end

end
