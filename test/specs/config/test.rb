Configuration.new do

  jackal do
    require ["carnivore-actor", "jackal-packagecloud"]

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
