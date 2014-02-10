require "test_helper"
require "runtime"

class RuntimeTest < Test::Unit::TestCase
  def test_get_constant
    assert_not_nil Runtime["Object"]
  end
  
  def test_create_an_object
    assert_equal Runtime["Object"], Runtime["Object"].new.runtime_class
  end
  
  
end