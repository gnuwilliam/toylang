class Lexer
  KEYWORDS = ["def", "class", "if", "true", "false", "nil"]

  def tokenize(code)
    # cleanup code by remove extra line breaks
    code.chomp!

    # current character position we're parsing
    i = 0

    # collection of all parsed tokens in the form [:TOKEN_TYPE, value]
    tokens = []
  end
end