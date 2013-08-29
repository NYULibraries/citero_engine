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
      self.protocol = args[:protocol]
      self.url = args[:url]
      self.method = (args[:method] or "POST")
      self.enctype = (args[:enctype] or "application/x-www-form-urlencoded")
      self.element_name = (args[:element_name] or "data")
    end
    
    def url
      if @protocol.empty?
        @url
      else
        "#{@protocol}://#{@url}"
      end
    end

    def url=(str)
      if str.downcase.start_with? "http://"
        self.protocol = :http
      elsif str.downcase.start_with? "https://"
        self.protocol = :https
      end
      str = self.protocol.eql?(:http) ? str.gsub(/http:\/\//, "") : str.gsub(/https:\/\//, "")
      @url = str
    end
    
    def protocol
      @protocol
    end

    def protocol=(str)
      url="#{str}://#{@url}" unless str.nil?
      @protocol = str
    end
  end
end