module ExCite
  module ApplicationHelper
    def build_external_form
      return "<textarea name=\"#{@elements[:name]}\" id=\"#{@elements[:name]}\">#{@output}</textarea>"
    end
  end
end
