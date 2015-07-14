Configuration.new do

  jackal do
    require ["carnivore-actor", "jackal-packagecloud"]

    assets do
      connection do
        provider 'local'
        credentials do
          object_store_root File.dirname(File.dirname(__FILE__))
        end
      end
      bucket 'packages'
    end

    packagecloud do
      config do
        api_key ENV['PACKAGECLOUD_API_KEY']
        account_name ENV['PACKAGECLOUD_ACCOUNT_NAME']
      end

      sources do
        input  { type 'actor' }
        output { type 'spec' }
      end

      callbacks ['Jackal::Packagecloud::Pusher']
    end
  end

end
