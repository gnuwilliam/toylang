require "test_helper"
require "lexer"

class LexerTest < Test::Unit::TestCase
  def test_number
    assert_equal [[:NUMBER, 1]], Lexer.new.tokenize("1")
  end
end