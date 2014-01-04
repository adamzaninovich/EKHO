DevicePoller =
  poll: ->
    setTimeout @request, 1000

  request: ->
    $.get $('#now-playing').data('url')

jQuery ->
  if $('#now-playing').length > 0
    DevicePoller.poll()

window.DevicePoller = DevicePoller

