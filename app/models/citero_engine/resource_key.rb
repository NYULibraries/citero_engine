module CiteroEngine
  module ResourceKey
    def self.included(klass)
      klass.class_eval do
        attr_writer :resource_key
      end
    end
    # Construct a resource key if it doesn't already exist
    def resource_key 
      @resource_key ||= Digest::SHA1.hexdigest(_data)
    end
  end
end