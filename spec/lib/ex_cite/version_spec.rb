require 'rails_helper'

describe ExCite do
  describe "VERSION" do
    subject{ described_class::VERSION }
    it { is_expected.to be_present }
  end
end
