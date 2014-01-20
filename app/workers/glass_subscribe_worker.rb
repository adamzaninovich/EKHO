class GlassSubscribeWorker
  include Sidekiq::Worker

  PUBLIC_HOST = "https://mirrornotifications.appspot.com/forward?url=http://weepingangel.no-ip.info:8000"

  def perform user_id
    user = User.find(user_id)
    api = user.get_mirror_api_client
    api.subscriptions.insert collection: "location", userToken: user.id, callbackUrl: "#{PUBLIC_HOST}/glass/location_update"
    api.subscriptions.insert collection: "timeline", userToken: user.id, operation: ["UPDATE"], callbackUrl: "#{PUBLIC_HOST}/glass/control"
  end

end
