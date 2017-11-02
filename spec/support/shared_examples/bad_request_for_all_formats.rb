RSpec.shared_examples "bad_request for all from_format and to_format" do
  context "from CSF" do
    let(:from_format){ "csf" }
    include_examples "bad_request for all to_format"
  end

  context "from BibTeX" do
    let(:from_format){ "bibtex" }
    include_examples "bad_request for all to_format"
  end

  context "from Refworks" do
    let(:from_format){ "refworks_tagged" }
    include_examples "bad_request for all to_format"
  end

  context "from RIS" do
    let(:from_format){ "ris" }
    include_examples "bad_request for all to_format"
  end

  context "from openurl" do
    let(:from_format){ "openurl" }
    include_examples "bad_request for all to_format"
  end

  context "from PNX" do
    let(:from_format){ "pnx" }
    include_examples "bad_request for all to_format"
  end
end

RSpec.shared_examples "bad_request for all to_format" do |from_format|
  context "to openurl" do
    let(:to_format){ "openurl" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to ris" do
    let(:to_format){ "ris" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to refworks_tagged" do
    let(:to_format){ "refworks_tagged" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to refworks" do
    let(:to_format){ "refworks" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to bibtex" do
    let(:to_format){ "bibtex" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to easybib" do
    let(:to_format){ "easybib" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to easybibpush" do
    let(:to_format){ "easybibpush" }
    its(:status) { is_expected.to eq 400 }
  end
  context "to csf" do
    let(:to_format){ "csf" }
    its(:status) { is_expected.to eq 400 }
  end
end
