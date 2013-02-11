module CiteroEngine
  module ActsAsCitable
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def acts_as_citable(options = {})
        cattr_accessor :format_field
        cattr_accessor :title_field
        cattr_accessor :raw_field
        self.format_field = (options[:format_field] || :formatting).to_s
        self.title_field = (options[:title_field] || :title).to_s
        self.raw_field = (options[:raw_field] || :raw).to_s
      end
    end
    
    def format(string)
      write_attribute(self.class.format_field, string)
    end
    
  end
end
 
ActiveRecord::Base.send :include, CiteroEngine::ActsAsCitable