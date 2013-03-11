require 'test_helper'

module CiteroEngine
  class RecordTest < ActiveSupport::TestCase

    test "typeones fields should be records fields" do
      assert_equal "formatting", TypeOne.format_field
    end

    test "test a typetwos fields should be records fields" do
      assert_equal "from_format", TypeTwo.format_field
    end

    test "test typeones formatting should populate records fields" do
      typeone = TypeOne.new(:formatting => "CSF", :raw => "itemType: book")
      # typeone.formatting("CSF")
      # p typeone.to_ris
      assert_equal "CSF", typeone.formatting
    end

    test "test typetwos formatting should populate records fields" do
      # typetwo = TypeTwo.new
      # typetwo.format("PNX")
      # assert_equal "PNX", typetwo.from_format
    end
  end
end