RSpec.shared_examples "success for all to_format" do |from_format|
  context "to openurl" do
    let(:to_format){ "openurl" }
    it { is_expected.to be_success }
    if from_format == "openurl"
      its(:body) { is_expected.to eq data }
    else
      its(:body) { is_expected.to eq "rft.ulr_ver=Z39.88-2004&rft.ctx_ver=Z39.88-2004&rfr_id=info:sid/libraries.nyu.edu:citero&rft_val_fmlt=info:ofi/fmt:kev:mtx:book&rft.genre=book" }
    end
  end
  context "to ris" do
    let(:to_format){ "ris" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to match /\ATY\s+-\s+BOOK\nER\s+-\n\n\z/ }
  end
  context "to refworks_tagged" do
    let(:to_format){ "refworks_tagged" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to eq "RT Book, whole\nER \n \n" }
  end
  context "to refworks" do
    let(:to_format){ "refworks" }
    it { is_expected.to be_success }
    it { is_expected.to render_template "ex_cite/cite/external_form" }
  end
  context "to bibtex" do
    let(:to_format){ "bibtex" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to eq "@book{????\n}" }
  end
  context "to easybib" do
    let(:to_format){ "easybib" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to eq "[{\"source\":\"book\",\"book\":{\"title\":null},\"pubtype\":{\"main\":\"pubnonperiodical\"},\"pubnonperiodical\":{},\"contributors\":[]}]" }
  end
  context "to easybibpush" do
    let(:to_format){ "easybibpush" }
    it { is_expected.to be_success }
    it { is_expected.to render_template "ex_cite/cite/external_form" }
  end
  context "to csl" do
    let(:to_format){ "csl" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to eq "[{\"ITEM-1\":{\"id\":\"ITEM-1\",\"type\":\"book\"}}]" }
  end
  context "to csf" do
    let(:to_format){ "csf" }
    it { is_expected.to be_success }
    its(:body) { is_expected.to match /\AitemType:\s*book(\s+importedFrom:\s*\w+)?\s*\z/ }
  end
end
