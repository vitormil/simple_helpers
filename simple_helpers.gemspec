# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require "simple_helpers/version"

Gem::Specification.new do |gem|
  gem.name          = "simple_helpers"
  gem.version       = SimpleHelpers::Version::STRING
  gem.platform      = Gem::Platform::RUBY

  gem.authors       = ["Vitor Oliveira"]
  gem.email         = ["vitormil@gmail.com"]
  gem.summary       = "Customizable helper methods with I18n support."
  gem.description   = gem.summary
  gem.homepage      = "http://rubygems.org/gems/simple_helpers"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 3.0.0"
  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"
end
