module CiteroEngine
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      # acts_as_citable
      attr_accessor :resource_key
      
      after_initialize :construct_key

      def construct_key
        @resource_key = Digest::SHA1.hexdigest(_data)
      end
    end
  end
end