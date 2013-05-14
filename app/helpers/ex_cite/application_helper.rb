module ExCite
  module ApplicationHelper
    def build_external_form
      return "<textarea name=\"#{@push_to.name}\" id=\"#{@push_to.name}\">#{@output}</textarea>"
    end
  end
end
