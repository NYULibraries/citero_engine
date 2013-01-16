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
  end
end
