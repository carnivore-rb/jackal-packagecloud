require 'jackal'

module Jackal
  module Packagecloud
    autoload :Pusher, 'jackal-packagecloud/pusher'
  end
end

require 'jackal-packagecloud/version'

Jackal.service(
  :packagecloud,
  :description => 'Send messages to Packagecloud',
  :configuration => {
    :webhook_url => {
      :description => 'Webhook URL to send messages'
    }
  }
)
