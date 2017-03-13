require 'rails_helper'

describe ExCite::Engine do
  describe "easybib" do
    subject{ ExCite.easybib }
    it { is_expected.to be_a ExCite::PushFormat }
    its(:name) { is_expected.to eq :easybibpush }
    its(:to_format) { is_expected.to eq :easybib }
    its(:action) { is_expected.to eq :render }
    its(:element_name) { is_expected.to eq 'data' }
    its(:url) { is_expected.to eq "http://www.easybib.com/cite/bulk" }
  end

  describe "endnote" do
    subject{ ExCite.endnote }
    it { is_expected.to be_a ExCite::PushFormat }
    its(:name) { is_expected.to eq :endnote }
    its(:to_format) { is_expected.to eq :ris }
    its(:action) { is_expected.to eq :redirect }
    its(:element_name) { is_expected.to eq 'data' }
    its(:url) { is_expected.to eq "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=" }
  end

  describe "refworks" do
    subject{ ExCite.refworks }
    it { is_expected.to be_a ExCite::PushFormat }
    its(:name) { is_expected.to eq :refworks }
    its(:to_format) { is_expected.to eq :refworks_tagged }
    its(:action) { is_expected.to eq :render }
    its(:element_name) { is_expected.to eq 'ImportData' }
    its(:url) { is_expected.to eq "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RefWorks%20Tagged%20Format&encoding=65001&url=" }
  end

  describe "push_formats" do
    subject{ ExCite.push_formats }
    it { is_expected.to be_a Hash }
    its(:keys){ is_expected.to match_array %i[easybibpush endnote refworks] }
    it "should have correct values" do
      expect(subject[:easybibpush]).to eq ExCite.easybib
      expect(subject[:endnote]).to eq ExCite.endnote
      expect(subject[:refworks]).to eq ExCite.refworks
    end
  end

  describe "acts_as_citable_class" do
    subject{ ExCite.acts_as_citable_class }
    it { is_expected.to eq ExCite::Citation }
  end

  describe "engine_name" do
    subject{ described_class.engine_name }
    it { is_expected.to eq "ex_cite" }
  end

  describe "asset_pipeline initializer" do
    subject{ Rails.application.config.assets.precompile }
    it { is_expected.to include 'ex_cite.js' }
  end

  describe "ActiveRecord::Base initializer" do
    subject{ EmptyModel.new }
    it { is_expected.to respond_to :resource_key }
  end
end
