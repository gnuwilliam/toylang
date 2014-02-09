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
        # keywords - special identifiers tagged with their own name
        # 'if' will result in an [:IF, "if"] token
        if KEYWORDS.include?(identifier)
          tokens << [identifier.upcase.to_sym, identifier]
        else
          # non-keyword identifiers include method and variable names
          tokens << [:IDENTIFIER, identifier]
        end

        # skip what was just parsed
        i += identifier.size

      # match class names and constants starting with a capital letter
      # 
      # match constants
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += constant.size

      # match numbers
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size

      end
    end
  end
end