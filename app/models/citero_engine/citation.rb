module CiteroEngine
  # Citation class, holds data from format and/or resource key
  class Citation
    extend ActsAsCitable
    # Required fields
    attr_reader :data, :from_format, :resource_key
    acts_as_citable do |c|
      c.format_field = :from_format
    end
    
    # Post initilaize hook
    def initialize *args
      @data = args[0]
      @from_format = args[1]
      (args[2].nil?) ? construct_key : @resource_key = args[2]
    end

    # Construct a resource key if it doesn't already exist
    def construct_key 
      @resource_key = Digest::SHA1.hexdigest(@data)
    end
    
  end
end