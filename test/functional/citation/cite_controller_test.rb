require 'test_helper'

module Citation
  class CiteControllerTest < ActionController::TestCase
    test "should get citation" do
      get(:index, "map" => "itemType: book", "from" => "csf", "to" => "pnx",  :use_route => :cite)
      assert_response :success
    end
  end
end
