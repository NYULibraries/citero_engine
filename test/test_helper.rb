unless ENV['TRAVIS']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
else
  require 'coveralls'
  Coveralls.wear!
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"


Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

$formats ||= Hash[
              :csf => "itemType: book",
              :ris => "TY  -  JOUR\nER  -\n\n",
              :openurl => "https://getit.library.nyu.edu/resolve?rft_val_fmt=info:ofi/fmt:kev:mtx:book",
              :bibtex => "@article{Adams2001\n}",
              :pnx => "<display><type>book</type></display>"
  ]
  
$acts_as_citable_classes = ["ExCite::Citation", "TypeOne"]