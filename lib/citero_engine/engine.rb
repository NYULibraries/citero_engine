require 'citero_engine/core_ext'
require "acts_as_citable"

module CiteroEngine
  class Engine < Rails::Engine
    isolate_namespace CiteroEngine
    engine_name "citero_engine"
  end
end
