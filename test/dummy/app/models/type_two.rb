class TypeTwo < ActiveRecord::Base
  acts_as_citable :format_field => :from_format, :title_field => :item, :raw_field => :data
end
