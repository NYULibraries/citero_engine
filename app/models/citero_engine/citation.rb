module CiteroEngine
  class Citation < ActiveRecord::Base
    attr_accessible :data, :from_format, :resource_key
    acts_as_citable do |c|
      c.format_field = 'from_format'
    end
    after_initialize :construct_key

    def construct_key 
      if read_attribute(:resource_key).nil? && read_attribute(:data) 
        write_attribute(:resource_key, Digest::SHA1.hexdigest(read_attribute(:data)))
      end
    end
  end
end
