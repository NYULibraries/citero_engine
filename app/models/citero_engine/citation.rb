module CiteroEngine
  # Citation class, holds data from format and/or resource key
  class Citation < ActiveRecord::Base
    # Required fields
    attr_accessible :data, :from_format, :resource_key
    # Setting up as acts as citable, setting from_format to format_field
    acts_as_citable do |c|
      c.format_field = 'from_format'
    end
    # Post initilaize hook
    after_initialize :construct_key

    # Construct a resource key if it doesn't already exist
    def construct_key 
      if read_attribute(:resource_key).nil? && read_attribute(:data) 
        write_attribute(:resource_key, Digest::SHA1.hexdigest(read_attribute(:data)))
      end
    end
  end
end
