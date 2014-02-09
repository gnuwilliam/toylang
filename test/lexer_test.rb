require "test_helper"
require "lexer"

class LexerTest < Test::Unit::TestCase
  def test_number
    assert_equal [[:NUMBER, 1]], Lexer.new.tokenize("1")
  end

  def test_string
    assert_equal [[:STRING, "hi"]], Lexer.new.tokenize('"hi"')
  end

  def test_identifier
    assert_equal [[:IDENTIFIER, "name"]], Lexer.new.tokenize('name')
  end
end