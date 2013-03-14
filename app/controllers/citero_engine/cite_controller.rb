require "citero_engine/engine"
require 'digest/sha1'
require 'open-uri'
module CiteroEngine
  # Logic behind the webservice. First it gathers all the resource keys and creates Citation objects out of them and then
  # it gathers any and all from formats and data variables that were sent via post and creates an array out of them. If the
  # array is still empty it uses the URL as an OpenURL. It then loops through the array and translates and caches (or fetches)
  # each one using acts_as_citable. It then either downloads the data or redirects to another webservice.
  class CiteController < ActionController::Base
    # There must be a destination format, or else this whole thing doesnt make sense
    before_filter :valid_to_format?
    
    # Sends bad request if there is no destination format
    def valid_to_format?
      head :bad_request unless to_format      
    end
    
    # Checks to see if destination format is valid and stores it in a class variable
    def to_format
      @to_format ||= whitelist_formats :to, params[:to_format]
    end
    private :to_format
    
    # Constructs an array containing all the citations
    def citations
     unless defined? @citations
      @citations = resource_citation + format_citation
      if @citations.empty?
        @citations << open_url_citation
      end
     end
     @citations
    end
    
    # Constructs new citation objects with only the citation key set, returns an array
    def resource_citation
      (params[:resource_key].nil?) ? [] :
        params[:resource_key].collect do |key|
           CiteroEngine.acts_as_citable_class.new :resource_key => key
        end
    end
    
    # Constructs new citation objects with data and source format set (the citation key is constructed automatically), returns an array
    def format_citation
      (params[:from_format].nil? || params[:data].nil?) ? [] :
        params[:from_format].collect.with_index do |format, index|
          # p ActsAsCitableClass.format_field
          CiteroEngine.acts_as_citable_class.new  CiteroEngine.acts_as_citable_class.data_field.to_sym => params[:data].to_a[index],   CiteroEngine.acts_as_citable_class.format_field.to_sym => (whitelist_formats :from, format)
        end
    end
    
    # Returns a single citation object with data and format set as the url and openurl respectively
    def open_url_citation
       CiteroEngine.acts_as_citable_class.new   CiteroEngine.acts_as_citable_class.data_field.to_sym => CGI::unescape(request.protocol+request.host_with_port+request.fullpath),   CiteroEngine.acts_as_citable_class.format_field.to_sym => (whitelist_formats :from, 'openurl')
    end
    
    # Maps the output and caches it, alternatively it fetches the already cached result. Seperates each output with two new lines.
    # Raises an argument error if any error is caught in mapping (usually the formats are messed up)
    def map
      @output ||= 
        citations.collect { |citation| Rails.cache.fetch(citation.resource_key+to_format) { citation.send(to_format) } }.join "\n\n"
    rescue Exception => exc
      raise ArgumentError, "#{exc}\n Data or source format not provided and/or mismatched. [citations => #{citations}, to_format => #{@to_format}]"
    end
    
    # Maps then decides wether its a push request or a download, catches all bad argument errors
    def index
      map
      serve
    rescue ArgumentError => exc
      handle_invalid_arguments exc
    end
    
    # Pushes to a web service if that is what was requested else it downloads
    def serve
      @push_to ? push : download
    end

    # Cleans the user input and finds the associated method for that format
    def whitelist_formats direction, format
      # if the params are nil then it returns nil
      if direction.nil? || format.nil?
        return
      end
      # if the to format is found, it returns the method name for that to format
      if (direction == :to && Citero.to_formats.include?(format.downcase))
        return "#{:to.to_s}_#{format.downcase}"
      # if the from format is found, it returns just that because the object already knows what method to call
      elsif (direction == :from && Citero.from_formats.include?(format.downcase))
        return format.downcase
      end
      # if the format is still not found, it might be a push request, check if that is the case
      if push_formats.include? format.to_sym
        @push_to = push_formats[format.to_sym]
        @to_format = @push_to[:format].downcase
        return "#{direction.to_s}_#{@to_format}"
      end
    end
    
    # For debugging purposes prints out the error. Also sends bad request header
    def handle_invalid_arguments exc
      logger.debug exc
      head :bad_request
    end

    # Redirects or calls a predefined method depending on the webservice selected
    def push
      # for redirects
      if @push_to[:action].eql? :redirect
        # Openurl is data
        @data = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
        # and redirect to the url supplied by the webservice and the callback url
        redirect_to @push_to[:url]+callback, :status => 303
      elsif @push_to[:action].eql? :method
        # call the method this service needs
        send @push_to[:method]
      end
    end

    # sends the data with utf-8 encoding
    def download
      send_data @output.force_encoding('UTF-8'), :filename => filename, :type => @to_format.formatize.to_sym
    end

    # The callback url is defined here
    def callback
      # Starts with current url minus the querystring..
      callback = "#{request.protocol}#{request.host_with_port}#{request.fullpath.split('?')[0]}?"
      citations.collect do |cite|
        # then adds a resource key for each cached resource
        callback += "resource_key[]=#{cite.resource_key}&"
      end
      # and finally the to format
      callback += "to_format=#{@to_format.formatize}"
      # url encode and return
      ERB::Util.url_encode(callback)
    end

    # Creates the filename and extension. Few are application specific
    def filename
      name = "export"
      case @to_format
      when "to_bibtex"
        name += ".bib"
      when "to_easybib"
        name += ".json"
      else
        name += "." + @to_format.formatize
      end
      name
    end
    
    # Defines the push formats, looking to move this out
    def push_formats
      @push_formats ||= Hash[:easybibpush => Hash[ :format => :easybib, :action => :method, :method => :push_to_easybib], 
                             :endnote => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='], 
                             :refworks => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url='] ]
    end
    
    # Defines a form for the push to easybib
    def push_to_easybib
      @elements = [{:name => "data", :value => "[" + @output + "]", :type => "textarea"}]
      @name = "Push to EasyBib"
      @action = "http://www.easybib.com/cite/bulk"
      @method = "POST"
      @enctype = "application/x-www-form-urlencoded"
      render :template => "citero_engine/cite/external_form"
    end
  end
end
