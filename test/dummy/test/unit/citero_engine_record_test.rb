require 'test_helper'

class CiteroEngineRecordTest < ActiveSupport::TestCase
  test "test the ability to modify the services on the fly" do
    CiteroEngine.easybib.url = "localhost"
    assert CiteroEngine.easybib.url.eql? "localhost"
    CiteroEngine.easybib.url = "http://www.easybib.com/cite/bulk"
  end
end
