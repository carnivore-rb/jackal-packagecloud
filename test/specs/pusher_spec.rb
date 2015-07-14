require 'jackal-packagecloud'
require 'pry'

if(ENV['PACKAGECLOUD_API_KEY'])
  class Jackal::Packagecloud::Pusher
    attr_accessor :test_payload
    # stub out actual packagecloud call and save args for expectations
    def upload_packages(packages)
      test_payload.set(:packages, packages)
    end
  end
end

describe Jackal::Packagecloud::Pusher do

  before do
    @runner = run_setup(:test)
    track_execution(Jackal::Packagecloud::Pusher)
  end

  after{ @runner.terminate if @runner && @runner.alive? }

  let(:actor) { Carnivore::Supervisor.supervisor[:jackal_packagecloud_input] }

  describe 'valid?' do
    it 'does not execute if missing config or payload data' do
      h = { :packagecloud => {} }
      payload = Jackal::Utils.new_payload(:test, h)
      result = transmit_and_wait(actor, payload, 5)
      callback_executed?(result).must_equal false
    end
  end

  describe 'execute' do
    it 'executes with valid payload / passes correct arguments to packagecloud gem' do
      result = transmit_and_wait(actor, valid_payload, 5)

      callback_executed?(result).must_equal(true)

      result.get(:data, :packagecloud, :uploaded).count.must_equal(2)

      result.get(:data, :packagecloud, :uploaded).each do |pkg|
        desc = pkg[:distro_description]
        # if description is present, we're working with debian package
        if(desc)
          desc.must_equal 'ubuntu/precise'
          pkg[:path].must_match(/test\.deb$/)
        else
          pkg[:path].must_match(/test-0.1.0\.gem$/)
        end
      end
    end
  end

  private

  def valid_payload
    Jackal::Utils.new_payload(:test,
      :packagecloud => {
        :packages => [
          {
            :distro_description => 'ubuntu/precise',
            :path => 'test.deb',
            :repo => 'jackal-test'
          },
          {
            :path => 'test-0.1.0.gem',
            :repo => 'jackal-test'
          }
        ]
      }
    )
  end

end
