# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_auditor/version"

Gem::Specification.new do |gem|
  gem.name        = 'rails_auditor'
  gem.version     = RailsAuditor::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.date        = '2012-05-11'
  
  gem.summary     = "An auditor for Rails apps"
  gem.description = "An auditor for Rails apps"
  gem.homepage    = 'http://github.com/ihid/rails_auditor'
  
  gem.authors     = ["Jeremy Walker"]
  gem.email       = 'jez.walker@gmail.com'
  
  gem.files       = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency("rspec")
end