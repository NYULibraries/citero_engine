require 'rails_helper'

describe CiteroEngine::ResourceKey do
  let(:included_resource_class){ Class.new{ include CiteroEngine::ResourceKey } }
  let(:included_resource){ included_resource_class.new }

  describe "resource_key" do
    subject{ included_resource.resource_key }
    context "without setting" do
      before { allow(Digest::SHA1).to receive(:hexdigest).and_return digest }
      let(:digest){ "yf408f" }
      pending 
    end
    context "with setting" do
      let(:digest){ "my_digest" }
      before { included_resource.resource_key = digest }
      it { is_expected.to eq digest }
    end
  end
end
