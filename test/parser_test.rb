require "test_helper"
require "parser"

class ParserTest < Test::Unit::TestCase
  def test_number
    assert_equal Nodes.new([NumberNode.new(1)]), Parser.new.parse("1")
  end
  
  def test_expression
    assert_equal Nodes.new([NumberNode.new(1), StringNode.new("hi")]), Parser.new.parse(%{1\n"hi"})
  end
  
  def test_call
    assert_equal Nodes.new([CallNode.new(NumberNode.new(1), "method", [])]), Parser.new.parse("1.method")
  end
  
  def test_call_with_arguments
    assert_equal Nodes.new([CallNode.new(nil, "method", [NumberNode.new(1), NumberNode.new(2)])]), Parser.new.parse("method(1, 2)")
  end
  
  def test_assign
    assert_equal Nodes.new([SetLocalNode.new("a", NumberNode.new(1))]), Parser.new.parse("a = 1")
    assert_equal Nodes.new([SetConstantNode.new("A", NumberNode.new(1))]), Parser.new.parse("A = 1")
  end
  
  
end