module CiteroEngine
  # Citation class, holds data from format and/or resource key
  class Citation
    extend ActsAsCitable
    include ResourceKey
    # Required fields
    attr_accessor :data, :from_format
    acts_as_citable do |c|
      c.format_field = :from_format
    end
    def initialize args = {}
      self.data = args[:data]
      self.from_format = args[:from_format]
      self.resource_key = args[:resource_key]
    end
    
    CiteroEngine.acts_as_citable_class = Citation
  end
end