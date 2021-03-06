# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'maigofuda/version'
build_version = File.read('BUILD_VERSION').strip if File.exist?('BUILD_VERSION')
version = Maigofuda::Version.string(build_version)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'maigofuda'
  spec.version     = version
  spec.authors     = ['Takahiro HAMAGUCHI']
  spec.email       = ['tk.hamaguchi@gmail.com']
  spec.homepage    = 'https://github.com/tk-hamaguchi/maigofuda'
  spec.summary     = "Rails' error handling more easy!"
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.required_ruby_version = '~> 2.7.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/tk-hamaguchi'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.0.3', '>= 6.0.3.2'
end
