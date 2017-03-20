require 'rails_helper'

describe ExCite::ExportCitationsController, type: :controller do
  routes { ExCite::Engine.routes }

  describe "GET index" do
    subject{ response }
    let(:csf_data){ "itemType: book" }
    let(:ris_data){ "TY  -  BOOK\nER  -\n\n" }
    let(:openurl_data){ "https://getit.library.nyu.edu/resolve?rft_val_fmt=info:ofi/fmt:kev:mtx:book" }
    let(:bibtex_data){ "@book{????\n}" }
    let(:pnx_data){ "<display><type>book</type></display>" }
    let(:refworks_data){ "RT Book, whole\nER \n \n" }

    context "with from_format" do
      context "with data" do
        before { get :index, to_format: to_format, from_format: from_format, data: data }

        context "valid data" do
          context "from CSF" do
            let(:from_format){ "csf" }
            let(:data){ csf_data }
            include_examples "book success for all to_format"
          end

          context "from BibTeX" do
            let(:from_format){ "bibtex" }
            let(:data){ bibtex_data }
            include_examples "book success for all to_format"
          end

          context "from Refworks" do
            let(:from_format){ "refworks_tagged" }
            let(:data){ refworks_data }
            include_examples "book success for all to_format"
          end

          context "from RIS" do
            let(:from_format){ "ris" }
            let(:data){ ris_data }
            include_examples "book success for all to_format"
          end

          context "from openurl" do
            let(:from_format){ "openurl" }
            let(:data){ openurl_data }
            include_examples "book success for all to_format", "openurl"
          end

          context "from PNX" do
            let(:from_format){ "pnx" }
            let(:data){ pnx_data }
            include_examples "book success for all to_format"
          end
        end

        context "invalid data" do
          let(:data){ "$%^$* some nonsense !@#$%^&*}" }

          # context "from CSF" do
          #   let(:from_format){ "csf" }
          #   include_examples "bad_request for all to_format"
          # end
          #
          # context "from BibTeX" do
          #   let(:from_format){ "bibtex" }
          #   include_examples "bad_request for all to_format"
          # end
          #
          # context "from Refworks" do
          #   let(:from_format){ "refworks_tagged" }
          #   include_examples "bad_request for all to_format"
          # end
          #
          # context "from RIS" do
          #   let(:from_format){ "ris" }
          #   include_examples "bad_request for all to_format"
          # end
          #
          # context "from openurl" do
          #   let(:from_format){ "openurl" }
          #   include_examples "bad_request for all to_format", "openurl"
          # end
          #
          # context "from PNX" do
          #   let(:from_format){ "pnx" }
          #   include_examples "bad_request for all to_format"
          # end
        end
      end

      context "with id" do
        before { get :index, to_format: to_format, from_format: from_format, id: id }

        context "invalid id" do
          let(:id) { "error" }

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

        context "valid id" do
          pending
        end
      end
    end
  end
end
