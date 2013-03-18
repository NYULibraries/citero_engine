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
      typeone = TypeOne.new(:formatting => "csf", :raw => "itemType: book")
      assert_equal "csf", typeone.formatting
    end

    test "test typetwos formatting should populate records fields" do
      CiteroEngine.acts_as_citable_class = "TypeOne"
      t = CiteroEngine.acts_as_citable_class.new(:formatting => "csf", :raw => "itemType: book")
      t.id = 1
      assert_equal t.to_ris, "TY  - BOOK\nER  -\n\n"
      CiteroEngine.acts_as_citable_class = "CiteroEngine::Citation"
    end
  end
end