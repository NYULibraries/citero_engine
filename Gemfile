source "http://rubygems.org"

# Declare your gem's dependencies in ex_cite.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

group :assets do
  gem "therubyrhino", "~> 2.0.4", platform: :jruby
  gem "therubyracer", "~> 0.12.1", platform: :ruby
  gem "uglifier", "~> 2.6.0"
end


gem "acts_as_citable", github: "NYULibraries/acts_as_citable", branch: "feature/rails4"
# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
