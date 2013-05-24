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
    config.before_initialize do
      ExCite.easybib ||= PushFormat.new( :name => :easybibpush, :to_format => :easybib, :url => "http://www.easybib.com/cite/bulk")
      ExCite.endnote ||= PushFormat.new :name => :endnote, :to_format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='
      ExCite.refworks ||= PushFormat.new( :name => :refworks, :to_format => :refworks_tagged, :element_name=> 'ImportData', :url => "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001")
      formats = Hash[ExCite.easybib.name => ExCite.easybib, ExCite.endnote.name => ExCite.endnote, ExCite.refworks.name => ExCite.refworks]
      ExCite.push_formats = formats
    end
  end

  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      include ResourceKey
    end
  end
end
