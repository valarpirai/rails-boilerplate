ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

ENV['EXECJS_RUNTIME'] = 'Node'

require 'bundler/setup' # Set up gems listed in the Gemfile.

ENV['RAILS_ENV'] ||= 'development'

unless %w[production staging].include?(ENV['RAILS_ENV'])
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end
