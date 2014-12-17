require 'test_helper'

class TypeTwoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "test a typetwos fields should be records fields" do
    assert_equal "from_format", TypeTwo.format_field
  end

  test "test typetwos formatting should populate records fields" do
    typetwo = TypeTwo.new(:from_format => "csf", :data => "itemType: book")
    assert_equal "csf", typetwo.from_format
  end
end
