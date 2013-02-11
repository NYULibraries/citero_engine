require 'test_helper'

module CiteroEngine
  class RecordTest < ActiveSupport::TestCase
    fixtures :"citero_engine/records"
    test "should not have null fields" do
      rec = Record.new
      assert !rec.save, "Saving a record with null fields"
    end
    test "should save a record and destroy it" do
      rec = Record.create(:raw => "data", :formatting => "format", :title => "title")
      assert rec.save
      assert rec.destroy
    end
    test "should get a record from db" do
      rec = Record.find_by_title("pnx")
      assert rec.valid?
    end

    test "typeones fields should be records fields" do
      assert_equal "formatting", TypeOne.format_field
      assert_equal "title", TypeOne.title_field
      assert_equal "raw", TypeOne.raw_field
    end

    test "test a typetwos fields should be records fields" do
      assert_equal "from_format", TypeTwo.format_field
      assert_equal "item", TypeTwo.title_field
      assert_equal "data", TypeTwo.raw_field
    end

    test "test typeones formatting should populate records fields" do
      typeone = TypeOne.new
      typeone.format("CSF")
      assert_equal "CSF", typeone.formatting
    end

    test "test typetwos formatting should populate records fields" do
      typetwo = TypeTwo.new
      typetwo.format("PNX")
      assert_equal "PNX", typetwo.from_format
    end
  end
end
