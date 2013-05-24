module ExCite
  module ApplicationHelper
    def build_external_form
      return "<textarea name=\"#{@push_to.element_name}\" id=\"#{@push_to.element_name}\">#{@output}</textarea>"
    end
  end
end
