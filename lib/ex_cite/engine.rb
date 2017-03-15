require 'ex_cite/core_ext'
require "acts_as_citable"
require 'citero_renderers'

module ExCite
  mattr_accessor :acts_as_citable_class
  mattr_accessor :push_formats
  mattr_accessor :endnote, :easybib, :refworks

  def self.acts_as_citable_class
    @@acts_as_citable_class.constantize
  end

  EASYBIB_URL = "http://www.easybib.com/cite/bulk"
  ENDNOTE_URL = "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl="
  REFWORKS_URL = "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001&url="

  class Engine < Rails::Engine
    isolate_namespace ExCite
    engine_name "ex_cite"
    ExCite.acts_as_citable_class = "ExCite::Citation"

    config.before_initialize do
      ExCite.easybib ||= PushFormat.new(name: :easybibpush, to_format: :easybib, url: EASYBIB_URL)
      ExCite.endnote ||= PushFormat.new(name: :endnote, to_format: :ris, action: :redirect, url: ENDNOTE_URL)
      ExCite.refworks ||= PushFormat.new(name: :refworks, to_format: :refworks_tagged, element_name: 'ImportData', url: REFWORKS_URL)
      formats = [ExCite.easybib, ExCite.endnote, ExCite.refworks]
      ExCite.push_formats = formats.map{|format| [format.name, format] }.to_h
    end

    initializer "#{engine_name}.asset_pipeline" do |app|
      app.config.assets.precompile << 'ex_cite.js'
    end
  end

  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      include ResourceKey
    end
  end
end
