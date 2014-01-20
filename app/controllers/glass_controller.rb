class GlassController < ApplicationController
  # disables csrf
  skip_before_action :verify_authenticity_token

  def location_update
    GlassLocationWorker.perform_async params["userToken"]
    render nothing: true
  end

  def control
    GlassDeviceControlWorker.perform_async params.fetch("userActions",[{}]).first.fetch("payload","")
    render nothing: true
  end
end
