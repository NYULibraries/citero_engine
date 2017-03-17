RSpec.shared_examples "bad_request for all to_format" do |from_format|
  context "to openurl" do
    let(:to_format){ "openurl" }
    it { is_expected.to be_bad_request }
  end
  context "to ris" do
    let(:to_format){ "ris" }
    it { is_expected.to be_bad_request }
  end
  context "to refworks_tagged" do
    let(:to_format){ "refworks_tagged" }
    it { is_expected.to be_bad_request }
  end
  context "to refworks" do
    let(:to_format){ "refworks" }
    it { is_expected.to be_bad_request }
  end
  context "to bibtex" do
    let(:to_format){ "bibtex" }
    it { is_expected.to be_bad_request }
  end
  context "to easybib" do
    let(:to_format){ "easybib" }
    it { is_expected.to be_bad_request }
  end
  context "to easybibpush" do
    let(:to_format){ "easybibpush" }
    it { is_expected.to be_bad_request }
  end
  context "to csl" do
    let(:to_format){ "csl" }
    it { is_expected.to be_bad_request }
  end
  context "to csf" do
    let(:to_format){ "csf" }
    it { is_expected.to be_bad_request }
  end
end
