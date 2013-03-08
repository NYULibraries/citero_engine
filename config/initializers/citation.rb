module CiteroEngine
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      attr_accessible :data, :from_format, :resource_key
      acts_as_citable do |c|
        c.format_field = 'from_format'
      end
      
      after_initialize :construct_key

      # Construct a resource key if it doesn't already exist
      def construct_key 
        if read_attribute(:resource_key).nil? && read_attribute(:data) 
          write_attribute(:resource_key, Digest::SHA1.hexdigest(read_attribute(:data)))
        end
      end
    end
  end
end