$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'jackal-packagecloud/version'
Gem::Specification.new do |s|
  s.name = 'jackal-packagecloud'
  s.version = Jackal::Packagecloud::VERSION.version
  s.summary = 'Jackal packagecloud'
  s.author = 'Heavywater'
  s.email = 'support@heavywater.io'
  s.homepage = 'http://github.com/carnivore-rb/jackal-packagecloud'
  s.description = 'Jackal packagecloud Integration'
  s.license = 'Apache 2.0'
  s.require_path = 'lib'
  s.add_dependency 'jackal', '>= 0.3.18', '< 1.0'
  s.add_dependency 'jackal-assets'
  s.add_dependency 'packagecloud-ruby', '~> 0.2.19'

  s.add_development_dependency 'carnivore-actor'

  s.files = Dir['lib/**/*'] + %w(jackal-packagecloud.gemspec README.md CHANGELOG.md CONTRIBUTING.md LICENSE)
end
