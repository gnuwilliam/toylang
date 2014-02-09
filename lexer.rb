class Lexer
  KEYWORDS = ["def", "class", "if", "true", "false", "nil"]

  def tokenize(code)
    # cleanup code by remove extra line breaks
    code.chomp!

    # current character position we're parsing
    i = 0

    # collection of all parsed tokens in the form [:TOKEN_TYPE, value]
    tokens = []

    # number of spaces in the last indent
    current_indent = 0

    # keep track of the indentation levels we are in so that when we dedent, we can
    # check if we're on the correct level.
    indent_stack = []

    # simple scanner implementation
    # scan one character at the time until find something to parse
    while i < code.size
      chunk = code[i..-1]

      # matching standard tokens
      #
      # match if, print, method names, etc
      if identifier = chunk[/\A([a-z]\w*)/, 1]
        
      end
    end
  end
end