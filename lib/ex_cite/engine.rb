require 'ex_cite/core_ext'
require "acts_as_citable"

module ExCite
  mattr_accessor :acts_as_citable_class
  mattr_accessor :push_formats
  def self.acts_as_citable_class
    @@acts_as_citable_class.constantize
  end

  class Engine < Rails::Engine
    isolate_namespace ExCite
    engine_name "ex_cite"
    ExCite.acts_as_citable_class = "ExCite::Citation"
  end
  
  def self.config &block
    if block
      yield self
    end
  end
  
  def self.push_formats
    @easybib ||= PushFormat.new( :name => :easybibpush, :to_format => :easybib, :action => :render, :template => "ex_cite/cite/external_form",
    :vars => Hash[
       "elements" => {:name => 'data', :type => 'textarea'},
       "name" => "Push",
       "action" => "http://www.easybib.com/cite/bulk",
       "method" => "POST",
       "enctype" => "application/x-www-form-urlencoded"
       ])
    @endnote ||= PushFormat.new :name => :endnote, :to_format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='
    @refworks ||= PushFormat.new( :name => :refworks, :to_format => :refworks_tagged, :action => :render, :template => "ex_cite/cite/external_form",
    :vars => Hash[
       "elements" => {:name => 'data', :type => 'textarea'},
       "name" => "Push",
       "action" => "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001",
       "method" => "POST",
       "enctype" => "application/x-www-form-urlencoded"
       ])
    @@push_formats ||= Hash[@easybib.name => @easybib, @endnote.name => @endnote, @refworks.name => @refworks]
  end
end
