# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in maigofuda.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :test do
  gem 'codecov', require: false
  gem 'rspec', '~> 3.9.0'
  gem 'rspec-its'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop', '~> 0.93.0'
  gem 'rubocop-faker'
  gem 'rubocop-junit-formatter'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end
