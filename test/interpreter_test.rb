require "test_helper"
require "interpreter"

class InterpreterTest < Test::Unit::TestCase
  def test_number
    assert_equal 1, Interpreter.new.eval("1").ruby_value
  end
  
  
end