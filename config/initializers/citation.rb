module CiteroEngine
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      # acts_as_citable
      attr_reader :resource_key
      after_initialize :setup_acts_as_citable

      def setup_acts_as_citable
        @resource_key =  Digest::SHA1.hexdigest(_data)
      end
    end
  end
end