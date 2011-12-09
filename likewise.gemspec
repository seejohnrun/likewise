require File.dirname(__FILE__) + '/lib/likewise/version'

spec = Gem::Specification.new do |s|
  s.name = 'likewise' 
  s.author = 'John Crepezzi'
  s.add_dependency('dalli')
  s.add_dependency('uuid')
  s.add_development_dependency('rspec')
  s.description = 'likewise'
  s.email = 'john.crepezzi@gmail.com'
  s.files = Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/brewster/likewise'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.summary = 'likewise'
  s.test_files = Dir.glob('spec/*.rb')
  s.version = Likewise::VERSION
end
