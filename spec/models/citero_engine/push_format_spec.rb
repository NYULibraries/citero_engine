require 'rails_helper'

describe CiteroEngine::PushFormat do
  let(:push_format){ described_class.new }

  describe "name" do
    subject{ push_format.name }
    it { is_expected.to eq 'Service' }
    context "initialized with name" do
      let(:push_format){ described_class.new name: "Some Name" }
      it { is_expected.to eq 'Some Name' }
    end
  end

  describe "to_format" do
    subject{ push_format.to_format }
    it { is_expected.to eq nil }
    context "initialized with name" do
      let(:push_format){ described_class.new to_format: :ala }
      it { is_expected.to eq :ala }
    end
  end

  describe "action" do
    subject{ push_format.action }
    it { is_expected.to eq :render }
    context "initialized with name" do
      let(:push_format){ described_class.new action: :some_action }
      it { is_expected.to eq :some_action }
    end
  end

  describe "template" do
    subject{ push_format.template }
    it { is_expected.to eq "citero_engine/cite/external_form" }
    context "initialized with name" do
      let(:push_format){ described_class.new template: "some/template/path" }
      it { is_expected.to eq "some/template/path" }
    end
  end

  describe "url" do
    subject{ push_format.url }
    it { is_expected.to eq nil }
    context "initialized with name" do
      let(:push_format){ described_class.new url: "http://example.com" }
      it { is_expected.to eq "http://example.com" }
    end
  end

  describe "method" do
    subject{ push_format.method }
    it { is_expected.to eq "POST" }
    context "initialized with name" do
      let(:push_format){ described_class.new method: "GET" }
      it { is_expected.to eq "GET" }
    end
  end

  describe "enctype" do
    subject{ push_format.enctype }
    it { is_expected.to eq "application/x-www-form-urlencoded" }
    context "initialized with name" do
      let(:push_format){ described_class.new enctype: "text/plain" }
      it { is_expected.to eq "text/plain" }
    end
  end

  describe "element_name" do
    subject{ push_format.element_name }
    it { is_expected.to eq "data" }
    context "initialized with name" do
      let(:push_format){ described_class.new element_name: "something_else" }
      it { is_expected.to eq "something_else" }
    end
  end

  describe "callback_protocol" do
    subject{ push_format.callback_protocol }
    it { is_expected.to eq :http }
    context "initialized with name" do
      let(:push_format){ described_class.new protocol: :tcp }
      it { is_expected.to eq :tcp }
    end
  end
end
