$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "citero_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "citero_engine"
  s.version     = CiteroEngine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-01-22'
  s.summary     = "Web engine to allow download and push capabilities to an array of bibiligraphic records."
  s.description = "Leverages citero-jruby gem and acts_as_citable to deliver a download and push mechanism."
  s.authors     = ["hab278"]
  s.email       = 'hab278@nyu.edu'
  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files  = Dir["test/**/*"]
  s.homepage    = "https://github.com/NYULibraries/citero_engine"

  s.add_dependency "rails", "~> 4.2.10"
  s.add_dependency "acts_as_citable", "~> 5.0.0.alpha5"
  s.add_dependency 'citero-renderers', '~> 1.0.4'
  s.add_dependency "jquery-rails", "~> 4.3.1"

  s.add_development_dependency "sqlite3", "~> 1.3.13"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "simplecov-rcov", "~> 0.2.3"
  s.add_development_dependency "test-unit", "~> 3.2.6"
  s.add_development_dependency "coveralls", "~> 0.8.21"
  s.add_development_dependency "pry", "~> 0.11.2"
  s.add_development_dependency "rspec-rails", "~> 3.5"
  s.add_development_dependency "rspec-html-matchers", "~> 0.9.1"
  s.add_development_dependency "rspec-its", "~> 1.2.0"
end
