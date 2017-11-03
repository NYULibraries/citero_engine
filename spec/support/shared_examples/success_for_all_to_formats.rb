RSpec.shared_examples "success for all to_format" do |from_format|
  context "to openurl" do
    let(:to_format){ "openurl" }
    its(:status) { is_expected.to eq OK }
  end
  context "to ris" do
    let(:to_format){ "ris" }
    its(:status) { is_expected.to eq OK }
  end
  context "to refworks_tagged" do
    let(:to_format){ "refworks_tagged" }
    its(:status) { is_expected.to eq OK }
  end
  context "to refworks" do
    let(:to_format){ "refworks" }
    its(:status) { is_expected.to eq OK }
    it { is_expected.to render_template "citero_engine/cite/external_form" }
  end
  context "to bibtex" do
    let(:to_format){ "bibtex" }
    its(:status) { is_expected.to eq OK }
  end
  context "to easybib" do
    let(:to_format){ "easybib" }
    its(:status) { is_expected.to eq OK }
  end
  context "to easybibpush" do
    let(:to_format){ "easybibpush" }
    its(:status) { is_expected.to eq OK }
    it { is_expected.to render_template "citero_engine/cite/external_form" }
  end
  context "to csf" do
    let(:to_format){ "csf" }
    its(:status) { is_expected.to eq OK }
  end
end
