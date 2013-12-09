class TypeTwo < ActiveRecord::Base
  if defined?(ActiveModel::MassAssignmentSecurity)
    attr_accessible :from_format, :data, :title
  else
    attr_reader :from_format, :data, :title
    attr_writer:from_format, :data, :title
  end
  acts_as_citable do |c|
    c.format_field = 'from_format'
  end
end
