class TypeTwo < ActiveRecord::Base
  attr_accessible :from_format, :data, :title
  acts_as_citable do |c|
    c.format_field = 'from_format'
  end
end
