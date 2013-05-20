require 'ex_cite/core_ext'
require "acts_as_citable"

module ExCite
  mattr_accessor :acts_as_citable_class
  mattr_accessor :push_formats
  mattr_accessor :endnote, :easybib, :refworks
  def self.acts_as_citable_class
    @@acts_as_citable_class.constantize
  end

  class Engine < Rails::Engine
    isolate_namespace ExCite
    engine_name "ex_cite"
    ExCite.acts_as_citable_class = "ExCite::Citation"
  end
end
