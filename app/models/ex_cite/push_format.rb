module ExCite
  # Citation class, holds data from format and/or resource key
  class PushFormat
    # Required fields
    attr_accessor :name, :to_format, :action, :vars, :template, :url, :method, :enctype, :element_name
    def initialize args = {}
      self.name = args[:name]
      self.to_format = args[:to_format]
      self.action = args[:action]
      self.vars = args[:vars]
      self.template = args[:template]
      self.url = args[:url]
      self.method = (args[:method] or "POST")
      self.enctype = (args[:enctype] or "application/x-www-form-urlencoded")
      self.element_name = (args[:element_name] or "data")
    end
  end
end