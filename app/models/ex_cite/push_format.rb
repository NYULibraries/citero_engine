module ExCite
  # Citation class, holds data from format and/or resource key
  class PushFormat
    # Required fields
    attr_accessor :name, :to_format, :action, :vars, :template, :url
    def initialize args = {}
      self.name = args[:name]
      self.to_format = args[:to_format]
      self.action = args[:action]
      self.vars = args[:vars]
      self.template = args[:template]
      self.url = args[:url]
    end
  end
end