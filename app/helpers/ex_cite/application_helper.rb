module ExCite
  module ApplicationHelper
    def build_external_form
      f = ""
      @elements.each do |element|
        # Return input element for no js and not textarea
        f += "<input name=\"#{element[:name]}\" type=\"#{(element[:type].nil?) ? "text" : element[:type]}\" value='#{element[:value]}' />" unless (element[:type] and element[:type].eql?("textarea"))
        # Return textarea element for no js and type=textarea
        f += "<textarea name=\"#{element[:name]}\" id=\"#{element[:name]}\">#{element[:value]}</textarea>" unless (element[:type].nil? or not element[:type].eql?("textarea"))
      end
      return f
    end
  end
end
