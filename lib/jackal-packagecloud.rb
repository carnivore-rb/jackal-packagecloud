require 'jackal'

module Jackal
  # Jackal Cloud integration
  module Packagecloud
    autoload :Pusher, 'jackal-packagecloud/pusher'
  end
end

require 'jackal-packagecloud/version'

Jackal.service(
  :packagecloud,
  :description => 'Upload packages to packagecloud',
  :configuration => {
    :account_name => {
      :description => 'packagecloud account name',
    },
    :api_key => {
      :description => 'packagecloud API key'
    },
    :default_repo => {
      :description => 'Default repository to push packages'
    }
  }
)
