require "test_helper"
require "runtime"

class RuntimeTest < Test::Unit::TestCase
  def test_get_constant
    assert_not_nil Runtime["Object"]
  end
  
  def test_create_an_object
    assert_equal Runtime["Object"], Runtime["Object"].new.runtime_class
  end
  
  def test_create_an_object_mapped_to_ruby_value
    assert_equal 32, Runtime["Number"].new_with_value(32).ruby_value
  end
  
  
end