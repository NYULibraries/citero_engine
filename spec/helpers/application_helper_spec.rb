require 'rails_helper'

describe ExCite::ApplicationHelper do
  describe "build_external_form" do
    subject{ helper.build_external_form }

    context "with @push_to format defined" do
      before { assign(:push_to, push_format) }
      let(:push_format) { instance_double ExCite::PushFormat, element_name: "something" }
      it { is_expected.to have_tag "textarea", with: {name: "something", id: "something"} }

      context "with @output" do
        before { assign(:output, "Some text") }
        it { is_expected.to have_tag "textarea", text: "Some text", with: {name: "something", id: "something"} }
      end
    end

    context "with @push_to format defined" do
      it "should raise an error" do
        expect{ subject }.to raise_error NoMethodError
      end
    end
  end
end
