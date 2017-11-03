require 'citero_engine/core_ext'
require "acts_as_citable"
require 'citero-renderers'

module CiteroEngine
  mattr_accessor :acts_as_citable_class
  mattr_accessor :push_formats
  mattr_accessor :endnote, :easybib, :refworks

  def self.acts_as_citable_class
    @@acts_as_citable_class = @@acts_as_citable_class.constantize if @@acts_as_citable_class.is_a? String
    @@acts_as_citable_class
  end

  EASYBIB_URL = "http://www.easybib.com/cite/bulk"
  ENDNOTE_URL = "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl="
  REFWORKS_URL = "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001&url="

  class Engine < Rails::Engine
    isolate_namespace CiteroEngine
    engine_name "citero_engine"
    CiteroEngine.acts_as_citable_class = "CiteroEngine::Citation"

    config.before_initialize do
      CiteroEngine.easybib ||= PushFormat.new(name: :easybibpush, to_format: :easybib, url: EASYBIB_URL)
      CiteroEngine.endnote ||= PushFormat.new(name: :endnote, to_format: :ris, action: :redirect, url: ENDNOTE_URL)
      CiteroEngine.refworks ||= PushFormat.new(name: :refworks, to_format: :refworks_tagged, element_name: 'ImportData', url: REFWORKS_URL)
      formats = [CiteroEngine.easybib, CiteroEngine.endnote, CiteroEngine.refworks]
      CiteroEngine.push_formats = formats.map{|format| [format.name, format] }.to_h
    end

    initializer "#{engine_name}.asset_pipeline" do |app|
      app.config.assets.precompile << 'citero_engine.js'
    end
  end

  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      include ResourceKey
    end
  end
end
