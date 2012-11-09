require 'test_helper'

module Citation
  class RecordTest < ActiveSupport::TestCase
    test "should not have null fields" do
      rec = Record.new
      assert !rec.save, "Saving a record with null fields"
    end
  end
end
