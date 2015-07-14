require 'jackal-packagecloud'

module Jackal
  module Packagecloud
    # Push packages to package cloud
    class Pusher < Jackal::Callback

      # Load up the package cloud library
      def setup(*_)
        require 'packagecloud'
        # This is a stupid fix for JSON dumping due to pure json lib
        # that's being included via the require above
        Fixnum.class_eval do
          def to_json(*args)
            to_s
          end
        end
      end

      # Config / payload requirements for Message to be considered valid
      #   and for execute method to run
      #
      # @param message [Carnivore::Message]
      # @return [TrueClass, FalseClass]
      def valid?(message)
        super do |payload|
          !payload.fetch(:data, :packagecloud, :packages, []).empty?
        end
      end

      # Process payload and push packages to package cloud
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |payload|
          packages = payload.get(:data, :packagecloud, :packages)
          upload_packages(packages)

          payload.set(:data, :packagecloud, :uploaded,
            payload[:data][:packagecloud].delete(:packages)
          )
          job_completed(:packagecloud_pusher, payload, message)
        end
      end

      # Create a new package cloud client instance
      #
      # @return [::Packagecloud::Client]
      def packagecloud_client
        [:account_name, :api_key].each do |k|
          unless(config[k])
            raise "Missing expected configuration item: `#{k}`"
          end
        end
        ::Packagecloud::Client.new(
          ::Packagecloud::Credentials.new(
            config[:account_name],
            config[:api_key]
          )
        )
      end

      # Upload packages to packagecloud
      #
      # @param packages [Array<Hash>] package list
      # @note `:path` is required and references the asset store.
      #   `:distro_description` and `:repo` are optional. Default
      #   `:repo` value is pulled for the configuration or set to `"test"`.
      # @return [::Packagecloud::Result]
      def upload_packages(packages)
        client = packagecloud_client
        packages.each do |pkg|
          # distro_description can be nil for gems and source tarballs
          # valid version strings (eg: ubuntu/precise):
          #   https://packagecloud.io/docs#os_distro_version
          description, path = pkg[:distro_description], pkg[:path]

          distro_id = description && client.find_distribution_id(description)
          package = ::Packagecloud::Package.new(*[asset_store.get(path), distro_id].compact)

          client.put_package(pkg.fetch(:repo, config.fetch(:default_repo, 'test')), package)
        end
      end

    end
  end
end
