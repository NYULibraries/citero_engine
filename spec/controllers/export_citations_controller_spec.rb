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
    let(:refworks_tagged_data){ "RT Book, whole\nER \n \n" }

    context "using data" do
      context "with from_format" do
        before { get :index, to_format: to_format, from_format: from_format, data: data }

        context "valid data" do
          let(:data){ public_send(:"#{from_format}_data") }

          context "from CSF" do
            let(:from_format){ "csf" }
            include_examples "book success for all to_format"
          end

          context "from BibTeX" do
            let(:from_format){ "bibtex" }
            include_examples "book success for all to_format"
          end

          context "from Refworks" do
            let(:from_format){ "refworks_tagged" }
            include_examples "book success for all to_format"
          end

          context "from RIS" do
            let(:from_format){ "ris" }
            include_examples "book success for all to_format"
          end

          context "from openurl" do
            let(:from_format){ "openurl" }
            include_examples "book success for all to_format", "openurl"
          end

          context "from PNX" do
            let(:from_format){ "pnx" }
            include_examples "book success for all to_format"
          end
        end

        context "invalid data" do
          let(:data){ "$%^$* some nonsense !@#$%^&*}" }

          pending
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
      end # end with from_format

      context "without from_format" do
        before { get :index, to_format: to_format, data: data }

        pending
      end
    end # with using data

    context "using id" do
      before { get :index, to_format: to_format, id: id }

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
        around do |example|
          old_acts_as_citable_class = ExCite.acts_as_citable_class
          ExCite.acts_as_citable_class = DummyPersistentCitation
          example.run
          ExCite.acts_as_citable_class = old_acts_as_citable_class
        end
        let(:citation){ DummyPersistentCitation.create(data: data, format: from_format) }
        let(:id){ citation.id }

        context "with valid data" do
          let(:data){ public_send(:"#{from_format}_data") }

          context "from CSF" do
            let(:from_format){ "csf" }
            include_examples "book success for all to_format"
          end

          context "from BibTeX" do
            let(:from_format){ "bibtex" }
            include_examples "book success for all to_format"
          end

          context "from Refworks" do
            let(:from_format){ "refworks_tagged" }
            include_examples "book success for all to_format"
          end

          context "from RIS" do
            let(:from_format){ "ris" }
            include_examples "book success for all to_format"
          end

          context "from openurl" do
            let(:from_format){ "openurl" }
            include_examples "book success for all to_format", "openurl"
          end

          context "from PNX" do
            let(:from_format){ "pnx" }
            include_examples "book success for all to_format"
          end
        end

        context "with invalid data" do
          pending
        end
      end # end valid id
    end #end using id

    context "using resource_key" do
      pending
    end
  end
end
