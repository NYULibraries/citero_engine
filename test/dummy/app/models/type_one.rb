class TypeOne < ActiveRecord::Base
  if defined?(ActiveModel::MassAssignmentSecurity)
    attr_accessible :formatting, :raw, :title
  else
    attr_reader :formatting, :raw, :title
    attr_writer :formatting, :raw, :title
  end
  acts_as_citable do |c|
    c.format_field = 'formatting'
    c.data_field = 'raw'
  end
end
