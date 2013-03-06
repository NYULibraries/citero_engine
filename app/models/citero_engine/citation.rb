module CiteroEngine
  class Citation < ActiveRecord::Base
    attr_reader :data, :from_format, :resource_key
    acts_as_citable do |c|
      c.format_field = 'from_format'
    end
    def initialize *args
      @data = args[0]
      @from_format = args[1]
      (args[2].nil?) ? construct_key : @resource_key = args[2]
    end

    def construct_key 
      @resource_key = Digest::SHA1.hexdigest(@data)
    end
  end
end
