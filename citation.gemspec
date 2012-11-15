$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "citation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "citation"
  s.version     = Citation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2012-10-12'
  s.summary     = "Tool to translate between bibliographic formats."
  s.description = "Leverages a Maven and a custom JAR and wraps it with JRuby"
  s.authors     = ["hab278"]
  s.email       = 'hab278@nyu.edu'
  #s.files       = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile", "README.md", "Jarfile"]
  

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "rake", "0.9.2.2"
  s.add_dependency "test-unit"

  s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
end
