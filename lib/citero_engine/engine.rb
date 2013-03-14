require 'citero_engine/core_ext'
require "acts_as_citable"

module CiteroEngine
  mattr_accessor :acts_as_citable_class
  def self.acts_as_citable_class
    @@acts_as_citable_class.constantize
  end

  class Engine < Rails::Engine
    isolate_namespace CiteroEngine
    engine_name "citero_engine"
    CiteroEngine.acts_as_citable_class = "CiteroEngine::Citation"
  end
end
