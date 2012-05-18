# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_parser/version"

Gem::Specification.new do |gem|
  gem.name        = 'rails_parser'
  gem.version     = RailsParser::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.date        = '2012-05-11'
  
  gem.summary     = "An parser for Rails apps"
  gem.description = "An parser for Rails apps"
  gem.homepage    = 'http://github.com/ihid/rails_parser'
  
  gem.authors     = ["Jeremy Walker"]
  gem.email       = 'jez.walker@gmail.com'
  
  gem.files       = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("awesome_print")
  
  gem.add_dependency("ruby_parser")
  gem.add_dependency("sexp_processor")
end