module ExCite
  ActiveSupport.on_load(:after_initialize) do
    ActiveRecord::Base.class_eval do
      include ResourceKey
    end
  end
  
  @@easybib = PushFormat.new( :name => :easybibpush, :to_format => :easybib, :url => "http://www.easybib.com/cite/bulk")
  @@endnote = PushFormat.new :name => :endnote, :to_format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='
  @@refworks = PushFormat.new( :name => :refworks, :to_format => :refworks_tagged, :element_name=> 'ImportData', :url => "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001")
  formats = Hash[@@easybib.name => @@easybib, @@endnote.name => @@endnote, @@refworks.name => @@refworks]
  @@push_formats = formats
end