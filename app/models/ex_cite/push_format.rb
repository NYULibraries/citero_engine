module ExCite
  # Citation class, holds data from format and/or resource key
  class PushFormat
    # Required fields
    attr_accessor :name, :to_format, :action, :template, :protocol, :url, :method, :enctype, :element_name
    def initialize args = {}
      self.name = (args[:name] or 'Service')
      self.to_format = args[:to_format]
      self.action = (args[:action] or :render)
      self.template = (args[:template] or "ex_cite/cite/external_form")
      self.url = args[:url]
      self.protocol ||= args[:protocol]
      self.method = (args[:method] or "POST")
      self.enctype = (args[:enctype] or "application/x-www-form-urlencoded")
      self.element_name = (args[:element_name] or "data")
    end
    
    def url
      (self.protocol.nil? || self.protocol.to_s.empty?) ? @url : "#{self.protocol}://#{@url}"
    end
    
    def url=str
      self.protocol = str.starts_with? "https" ? :https : :http
      @url = str.gsub(/https*:\/{2}/, "")
    end
  end
end