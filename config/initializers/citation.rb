module CiteroEngine
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      attr_accessible :resource_key
      # acts_as_citable
      after_initialize :setup_acts_as_citable

      def setup_acts_as_citable
        if !self.class.ancestors.include? ActsAsCitable::InstanceMethods
          acts_as_citable
        end
      end
    end
  end
end