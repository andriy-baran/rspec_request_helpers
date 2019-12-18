lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_request_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec_request_helpers'
  spec.version       = RspecRequestHelpers::VERSION
  spec.authors       = ['Andrii Baran']
  spec.email         = ['andriy.baran.v@gmail.com']

  spec.summary       = %q{A set of helpers for request test with RSpec}
  spec.homepage      = 'https://github.com/andriy-baran/rspec_request_helpers'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2.2'

  version_string = ['>= 3.0']

  spec.add_runtime_dependency 'activesupport', version_string
  spec.add_runtime_dependency 'actionpack',    version_string
  spec.add_runtime_dependency 'railties',      version_string
  spec.add_runtime_dependency 'rspec', '>= 2.4'

  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
end
