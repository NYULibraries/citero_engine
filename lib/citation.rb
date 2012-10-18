require "citation/engine"
module Citation
  extend self
  #Citation class, used in builder form as Citation.new.map("some data").from("some format").to("some format")
  class Citation
    require 'java'
    require 'citation.jar'

    java_import Java::EduNyuLibraryCitation::Citation
    java_import Java::edu.nyu.library.citation.Formats

    @item
    def from(format)
      begin
        @item = @item::from(Formats::valueOf(format.upcase))
        return self
      rescue Exception => e
        $stderr.print e
        raise TypeError, 'Invalid Format'
      end
    end
    def to(format)
      begin
        return @item::to(Formats::valueOf(format.upcase))
      rescue Exception => e
        $stderr.print e
        raise TypeError, 'Invalid Format'
      end
    end
   
    class << self
      def map(payload)
        return new(payload)
      end
      private :new
    end
   
    def initialize(payload)
      @item = Citation.map(payload)
      return self
    end
   
  end
   
  def map(payload)
    Citation.map(payload)
  end
end