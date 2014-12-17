class TypeTwo < ActiveRecord::Base
  acts_as_citable do |c|
    c.format_field = 'from_format'
  end
end
