require 'rails_helper'

describe ExCite::Citation do
  let(:citation){ described_class.new(attributes) }
  describe "acts_as_citable" do
    let(:attributes){ {data: "itemType: book", from_format: "csf"} }
    describe "to_ris" do
      subject{ citation.to_ris }
      it { is_expected.to eq "TY  - BOOK\nER  -\n\n" }
    end
    describe "to_bibtex" do
      subject{ citation.to_bibtex }
      it { is_expected.to eq "@book{????\n}" }
    end
    describe "to_openurl" do
      subject{ citation.to_openurl }
      it { is_expected.to eq "rft.ulr_ver=Z39.88-2004&rft.ctx_ver=Z39.88-2004&rfr_id=info:sid/libraries.nyu.edu:citero&rft_val_fmlt=info:ofi/fmt:kev:mtx:book&rft.genre=book" }
    end
    describe "to_easybib" do
      subject{ citation.to_easybib }
      it { is_expected.to eq "{\"source\":\"book\",\"book\":{\"title\":null},\"pubtype\":{\"main\":\"pubnonperiodical\"},\"pubnonperiodical\":{},\"contributors\":[]}" }
    end
    describe "to_csf" do
      subject{ citation.to_csf }
      it { is_expected.to eq "itemType: book" }
    end
    describe "to_refworks_tagged" do
      subject{ citation.to_refworks_tagged }
      it { is_expected.to eq "RT Book, whole\nER \n \n" }
    end
    describe "csf" do
      subject{ citation.csf }
      it { is_expected.to be_present }
    end

    # describe "to_apa" do
    #   subject{ citation.to_apa }
    #   it { is_expected.to eq "<div class=\"csl-bib-body\">\n  <div class=\"csl-entry\"> (n.d.).</div>\n</div>" }
    # end
    describe "to_mla" do
      subject{ citation.to_mla }
      it { is_expected.to eq "<div class=\"csl-bib-body\">\n  <div class=\"csl-entry\"> Print.</div>\n</div>" }
    end
    describe "to_chicago_author_date" do
      subject{ citation.to_chicago_author_date }
      it { is_expected.to eq "<div class=\"csl-bib-body\">\n\n[CSL STYLE ERROR: reference with no printed form.]\n</div>" }
    end

    describe "respond_to?" do
      subject{ citation }
      it { is_expected.to respond_to :to_ris }
      it { is_expected.to respond_to :to_bibtex }
      it { is_expected.to respond_to :to_openurl }
      it { is_expected.to respond_to :to_easybib }
      it { is_expected.to respond_to :to_csf }
      it { is_expected.to respond_to :to_refworks_tagged }
      it { is_expected.to respond_to :csf }
      it { is_expected.to respond_to :to_apa }
      it { is_expected.to respond_to :to_mla }
      it { is_expected.to respond_to :to_chicago_author_date }
      it { is_expected.to_not respond_to :to_random }
    end
    describe "method_missing" do
      it "should raise an error for undefined method" do
        expect{ citation.to_random }.to raise_error NoMethodError
      end
    end

    describe "self.format_field" do
      subject{ described_class.format_field }
      it { is_expected.to eq :from_format }
    end
    describe "self.data_field" do
      subject{ described_class.data_field }
      it { is_expected.to eq "data" }
    end
  end
end
