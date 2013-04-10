require 'citero_engine/core_ext'
require "acts_as_citable"

module CiteroEngine
  mattr_accessor :acts_as_citable_class
  mattr_accessor :push_formats
  def self.acts_as_citable_class
    @@acts_as_citable_class.constantize
  end

  class Engine < Rails::Engine
    isolate_namespace CiteroEngine
    engine_name "citero_engine"
    CiteroEngine.acts_as_citable_class = "CiteroEngine::Citation"
  end
  
  def self.config &block
    if block
      yield self
    end
  end
  
  def self.push_formats
    @easybib ||= PushFormat.new( :name => :easybibpush, :to_format => :easybib, :action => :render, :template => "citero_engine/cite/external_form",
    :vars => Hash[
       "elements" => [{:name => 'data', :value => "[ @output ]", :type => 'textarea'}],
       "name" => "Push to EasyBib",
       "action" => "http://www.easybib.com/cite/bulk",
       "method" => "POST",
       "enctype" => "application/x-www-form-urlencoded"
       ])
    @endnote ||= PushFormat.new :name => :endnote, :to_format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='
    # @refworks ||= PushFormat.new :name => :refworks, :to_format => :ris, :action => :redirect, :url => 'http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url='
    @refworks ||= PushFormat.new( :name => :refworks, :to_format => :ris, :action => :render, :template => "citero_engine/cite/external_form",
    :vars => Hash[
       "elements" => [{:name => 'ImportData', :value => "[ @output ]", :type => 'textarea'}],
       "name" => "ExportRWForm",
       "action" => "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001",
       "method" => "POST",
       "enctype" => "application/x-www-form-urlencoded"
       ])
    @@push_formats ||= Hash[@easybib.name => @easybib, @endnote.name => @endnote, @refworks.name => @refworks]
  end
end
