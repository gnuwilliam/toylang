require "test_helper"
require "runtime"

class RuntimeTest < Test::Unit::TestCase
  def test_get_constant
    assert_not_nil Runtime["Object"]
  end
  
  
end