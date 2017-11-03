require 'rails_helper'

describe CiteroEngine::Engine do
  describe "easybib" do
    subject{ CiteroEngine.easybib }
    it { is_expected.to be_a CiteroEngine::PushFormat }
    its(:name) { is_expected.to eq :easybibpush }
    its(:to_format) { is_expected.to eq :easybib }
    its(:action) { is_expected.to eq :render }
    its(:element_name) { is_expected.to eq 'data' }
    its(:url) { is_expected.to eq "http://www.easybib.com/cite/bulk" }
  end

  describe "endnote" do
    subject{ CiteroEngine.endnote }
    it { is_expected.to be_a CiteroEngine::PushFormat }
    its(:name) { is_expected.to eq :endnote }
    its(:to_format) { is_expected.to eq :ris }
    its(:action) { is_expected.to eq :redirect }
    its(:element_name) { is_expected.to eq 'data' }
    its(:url) { is_expected.to eq "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=" }
  end

  describe "refworks" do
    subject{ CiteroEngine.refworks }
    it { is_expected.to be_a CiteroEngine::PushFormat }
    its(:name) { is_expected.to eq :refworks }
    its(:to_format) { is_expected.to eq :refworks_tagged }
    its(:action) { is_expected.to eq :render }
    its(:element_name) { is_expected.to eq 'ImportData' }
    its(:url) { is_expected.to eq "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001&url=" }
  end

  describe "push_formats" do
    subject{ CiteroEngine.push_formats }
    it { is_expected.to be_a Hash }
    its(:keys){ is_expected.to match_array %i[easybibpush endnote refworks] }
    it "should have correct values" do
      expect(subject[:easybibpush]).to eq CiteroEngine.easybib
      expect(subject[:endnote]).to eq CiteroEngine.endnote
      expect(subject[:refworks]).to eq CiteroEngine.refworks
    end
  end

  describe "acts_as_citable_class" do
    subject{ CiteroEngine.acts_as_citable_class }
    it { is_expected.to eq CiteroEngine::Citation }
  end

  describe "acts_as_citable_class=" do
    subject{ CiteroEngine.acts_as_citable_class = new_class }
    let(:fake_class){ Class.new }
    before { stub_const("DummyClass", fake_class) }

    around do |example|
      old_acts_as_citable_class = CiteroEngine.acts_as_citable_class
      example.run
      CiteroEngine.acts_as_citable_class = old_acts_as_citable_class
    end

    context "assigned as a string" do
      let(:new_class){ "DummyClass" }

      it "should assign correctly" do
        subject
        expect(CiteroEngine.acts_as_citable_class).to eq DummyClass
      end
    end

    context "assigned as a constant" do
      let(:new_class){ DummyClass }

      it "should assign correctly" do
        subject
        expect(CiteroEngine.acts_as_citable_class).to eq DummyClass
      end
    end
  end

  describe "engine_name" do
    subject{ described_class.engine_name }
    it { is_expected.to eq "citero_engine" }
  end

  describe "asset_pipeline initializer" do
    subject{ Rails.application.config.assets.precompile }
    it { is_expected.to include 'citero_engine.js' }
  end

  describe "ActiveRecord::Base initializer" do
    subject{ EmptyModel.new }
    it { is_expected.to respond_to :resource_key }
  end
end
