module CiteroEngine
  # Citation class, holds data from format and/or resource key
  class Citation
    extend ActsAsCitable
    # Required fields
    attr_accessor :data, :from_format, :resource_key
    acts_as_citable do |c|
      c.format_field = :from_format
    end
    def initialize args = {}
      @data = args[:data]
      @from_format = args[:from_format]
      (args[:resource_key].nil?) ? construct_key : @resource_key = args[:resource_key]
    end

    # Construct a resource key if it doesn't already exist
    def construct_key 
      @resource_key = Digest::SHA1.hexdigest(@data)
    end
  end
  
  ActsAsCitableClass = Citation
end