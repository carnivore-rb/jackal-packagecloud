require 'jackal-packagecloud'
require 'pry'

class Jackal::Packagecloud::Pusher
end

describe Jackal::Packagecloud::Pusher do

  before do
    @runner = run_setup(:test)
    track_execution(Jackal::Packagecloud::Pusher)
  end

  after  { @runner.terminate if @runner && @runner.alive? }

  let(:actor) { Carnivore::Supervisor.supervisor[:jackal_packagecloud_input] }

  describe 'valid?' do
    it 'executes with valid payload' do
      result = transmit_and_wait(actor, valid_payload, 3)
      puts '-'*80
      puts result.inspect
      binding.pry
      callback_executed?(result).must_equal true
    end
  end

  describe 'execute' do
    it 'passes correct data/format to packagecloud-notifier' do
    end
  end

  private

  def path(relative)
    File.expand_path(File.join('..', 'packages', relative), __FILE__)
  end

  def valid_payload
    h = { :packagecloud => {
            :packages => [ { :distro_description => 'ubuntu/precise',
                             :path => path('deb/test.deb') },
                           { :path => path('gem/test-0.1.0.gem') }]}}
    Jackal::Utils.new_payload(:test, h)
  end

end
