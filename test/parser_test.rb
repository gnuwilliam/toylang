require "test_helper"
require "parser"

class ParserTest < Test::Unit::TestCase
  def test_number
    assert_equal Nodes.new([NumberNode.new(1)]), Parser.new.parse("1")
  end
  
  def test_expression
    assert_equal Nodes.new([NumberNode.new(1), StringNode.new("hi")]), Parser.new.parse(%{1\n"hi"})
  end
  
  
end