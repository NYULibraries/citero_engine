$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ex_cite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ex_cite"
  s.version     = ExCite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-01-22'
  s.summary     = "Web engine to allow download and push capabilities to an array of bibiligraphic records."
  s.description = "Leverages citero-jruby gem and acts_as_citable to deliver a download and push mechanism."
  s.authors     = ["hab278"]
  s.email       = 'hab278@nyu.edu'
  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files  = Dir["test/**/*"]
  s.homepage    = "https://github.com/NYULibraries/ex_cite"

  s.add_dependency "rails", "~> 4.2.8"
  s.add_dependency "acts_as_citable", "~> 4.0.0"
  s.add_dependency 'citero_renderers', '~> 1.0.1'
  s.add_dependency "jquery-rails", "~> 3.1.0"

  s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "brakeman", "~> 1.9.5"
  s.add_development_dependency "simplecov-rcov"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails", "~> 3.5"
  s.add_development_dependency "rspec-html-matchers"
  s.add_development_dependency "rspec-its"
end
