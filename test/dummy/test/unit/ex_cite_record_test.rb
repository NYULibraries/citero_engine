require 'test_helper'

class ExCiteRecordTest < ActiveSupport::TestCase
  test "test the ability to modify the services on the fly" do
    ExCite.easybib.url = "localhost"
    assert ExCite.easybib.url.eql? "localhost"
    ExCite.easybib.url = "http://www.easybib.com/cite/bulk"
  end
end
