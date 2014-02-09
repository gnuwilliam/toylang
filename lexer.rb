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

      # match strings
      elsif string = chunk[/\A"(.*?)"/, 1]
        tokens << [:STRING, string]
        i += string.size + 2

      # indentation handler
      # 
      # 3 cases to take care of
      #
      #    if true: # 1) the block is created
      #      line 1
      #      line 2 # 2) new line inside a block
      #    continue # 3) dedent
      #
      # this elsif takes care of the first case
      # the number of spaces will determine the indent level
      elsif indent = chunk[/\A\:\n( +)/m, 1] # matches ": <newline> <spaces>"
        # when a new block is created, we spect the indent leve to go up
        if indent.size <= current_indent
          raise "Bad indent level, got #{indent.size} indents, " +
                "expected > #{current_indent}"
        end

        # adjust the current indentation level
        current_indent = indent.size
        indent_stack.push(current_indent)
        tokens << [:INDENT, indent.size]
        i += indent.size + 2

      # this elsif takes care of the two last cases
      # case 2: stay in the same block if the indent level (number of spaces)
      #         is the same as current_indent
      # 
      # case 3: close the current block, if indent level is lower than current_indent
      elsif indent = chunk[/\A\n( *)/m, 1] # matches "<newline> <spaces>"
        if indent.size == current_indent # case 2
          # nothing to do, still in the same block
          tokens << [:NEWLINE, "\n"]

        elsif indent.size < current_indent # case 3
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.first || 0
            tokens << [:DEDENT, indent.size]
          end
          tokens << [:NEWLINE, "\n"]
        else # indent.size > current_indent => error!
          # cannot increase indent level without using ":", so this is an error
          raise "Missing ':'"
        end
        i += indent.size + 1

      # match long operators such as ||, &&, ==, !=, <= and >=
      # one character long operators are matched by the catch all `else` at the bottom
      elsif operator = chunk[/\A(\|\||&&|==|!=|<=|=>)/, 1]
        tokens << [operator, operator]
        i += operator.size

      # ignore whitespace
      elsif chunk.match(/\A /)
        i += 1

      # catch all single characters
      # threat all other single chars as a token. eg.: ( ) , . ! + - <
      else
        value = chunk[0, 1]
        tokens << [value, value]
        i += 1
      end
    end

    # close all open blocks
    while indent = indent_stack.pop
      tokens << [:DEDENT, indent_stack.first || 0]
    end
  end
end