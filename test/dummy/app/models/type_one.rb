class TypeOne < ActiveRecord::Base
  attr_accessible :formatting, :raw, :title
  acts_as_citable do |c|
    c.format_field = 'formatting'
    c.data_field = 'raw'
  end
end
