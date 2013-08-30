$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ex_cite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ex_cite"
  s.version     = ExCite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-06-13'
  s.summary     = "Web engine to allow download and push capabilities to an array of bibiligraphic records."
  s.description = "Leverages citero-jruby gem and acts_as_citable to deliver a download and push mechanism."
  s.authors     = ["hab278"]
  s.email       = 'hab278@nyu.edu'
  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["test/**/*"]
  s.homepage    = "https://github.com/NYULibraries/ExCite"

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "rake", "~> 10.0"
  s.add_dependency "rails_config"
  s.add_dependency "jquery-rails", "~> 2.2"
  s.add_dependency "acts_as_citable", "~> 2.0.0"

  s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
  s.add_development_dependency "brakeman", "~> 1.9.5"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-rcov"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "coveralls"
end
