require './lib/flag_manager/version'

Gem::Specification.new do |gs|
  gs.name = 'Flag Manager'
  gs.version = FlagManager::VERSION
  gs.summary = 'Feature Flag Manager'

  gs.authors = ['Valar']
  gs.email = 'valarpiraichandran@gmail.com'

  gs.files = Dir['lib/**/*']
  gs.homepage = %q{http://github.com/valarpirai/rails-boilerplate}
  gs.require_paths = ['lib']
end
