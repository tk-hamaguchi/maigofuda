$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "maigofuda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "maigofuda"
  spec.version     = Maigofuda::VERSION
  spec.authors     = ["Takahiro HAMAGUCHI"]
  spec.email       = ["tk.hamaguchi@gmail.com"]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of Maigofuda."
  spec.description = "TODO: Description of Maigofuda."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.2"
end