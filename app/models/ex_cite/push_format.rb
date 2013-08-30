module ExCite
  # Citation class, holds data from format and/or resource key
  class PushFormat
    # Required fields
    attr_accessor :name, :to_format, :action, :template, :url, :method, :enctype, :element_name, :callback_protocol
    alias :protocol= :callback_protocol=
    def initialize args = {}
      self.name = (args[:name] or 'Service')
      self.to_format = args[:to_format]
      self.action = (args[:action] or :render)
      self.template = (args[:template] or "ex_cite/cite/external_form")
      self.url = args[:url]
      self.method = (args[:method] or "POST")
      self.enctype = (args[:enctype] or "application/x-www-form-urlencoded")
      self.element_name = (args[:element_name] or "data")
      self.callback_protocol = (args[:protocol] or :http)
    end
  end
end