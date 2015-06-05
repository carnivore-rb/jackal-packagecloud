require 'jackal-packagecloud'

module Jackal
  module Packagecloud
    class Pusher < Jackal::Callback

      def setup(*_)
        require 'packagecloud'
      end

      # Config / payload requirements for Message to be considered valid
      #   and for execute method to run
      #
      # @param message [Carnivore::Message]
      # @return [Boolean]
      def valid?(message)
        super do |payload|
          pkgs = payload.get(:data, :packagecloud, :packages)
          !!(config[:api_key] && config[:account_name] && pkgs && !pkgs.empty?)
        end
      end

      def execute(message)
        failure_wrap(message) do |payload|
          client = packagecloud_client
          payload.get(:data, :packagecloud, :packages).each do |pkg|
            # distro_description can be nil for gems and source tarballs
            # valid version strings (eg: ubuntu/precise):
            #   https://packagecloud.io/docs#os_distro_version
            description, path = pkg[:distro_description], pkg[:path]

            distro_id = description && client.find_distribution_id(description)
            package = ::Packagecloud::Package.new(*[open(path), distro_id].compact)

            client.put_package("test", package)
          end

          payload[:data][:packagecloud].delete(:packages)
          job_completed(:packagecloud_pusher, payload, message)
        end
      end

      def packagecloud_client
        acct_name, acct_key = config[:account_name], config[:api_key]
        credentials = ::Packagecloud::Credentials.new(acct_name, acct_key)
        ::Packagecloud::Client.new(credentials)
      end

    end
  end
end
