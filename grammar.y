class Parser

# declare tokens produced by the lexer
token IF ELSE
token DEF
token CLASS
token NEWLINE
token NUMBER
token STRING
token TRUE FALSE NIL
token IDENTIFIER
token CONSTANT
token INDENT DEDENT

# precedence table
# based on http://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B#Operator_precedence
prechigh
  left '.'
  right '!'
  left '*' '/'
  left '+' '-'
  left '>' '>=' '<' '<='
  left '==' '!='
  left '&&'
  left '||'
  right '='
  left ','
preclow

rule 
  # all rules are declared in this format:
  #
  #    Rulename:
  #      OtherRule TOKEN AnotherRule    { code to run when this matches }
  #    | OtherRule                      { ... }
  #    ;
  #
  # in the code section (inside the {...} on the right):
  #   - assign to "result" the value returned by the rule
  #   - use val[index of expresion] to reference the expressions on the left

  # all parsing will end in this rule, being the trunk of the AST
  Root:
    /* nothing */                       { result = Nodes.new([]) }
  | Expressions                         { result = val[0] }
  ;

  # any list of expressions, class or method body, separated by line breaks
  Expressions
    Expression                          { result = Nodes.new(val) }
  | Expressions Terminator Expression   { result = val[0] << val[0] }
  # to ignore trailing line breaks
  | Expressions Terminator              { result = val[0] }
  | Terminator                          { result = Nodes.new([]) }

  # all types of expressions in the language
  Expression
    Literal
  | Call
  | Operator
  | Constant
  | Assign
  | Def
  | Class
  | If
  | '(' Expression ')'                  { result = val[1] }
  ;

  # all tokens that can terminate an expression
  Terminator:
    NEWLINE
  | ";"
  ;

  # all hard-coded values
  Literal:
    NUMBER                              { result = NumberNode.new(val[0]) }
  | STRING                              { result = StringNode.new(val[0]) }
  | TRUE                                { result = TrueNode.new }
  | FALSE                               { result = FalseNode.new }
  | NIL                                 { result = NilNode.new }
  ;

  # a method call
  Call:
    # method
    IDENTIFIER                          { result = CallNode.new(nil, val[0], []) }
    # method (arguments)
  | IDENTIFIER "(" ArgList ")"          { result = CallNode.new(nil, val[0], val[2]) }
    # receiver.method
  | Expression "." IDENTIFIER           { result = CallNode.new(val[0], val[2], []) }
    # receiver.method (arguments)
  | Expression "."
      IDENTIFIER "(" ArgList ")"        { result = CallNode.new(val[0], val[2], val[4]) }
  ;

  ArgList:
    /* nothing */                       { result = [] }
  | Expression                          { result = val }
  | ArgList "," Expression              { result = val[0] << val[2] }
  ;

  Operator:
    # binary operators
    Expression '||' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '&&' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '==' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '!=' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>=' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<=' Expression          { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '+' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '-' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '*' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '/' Expression           { result = CallNode.new(val[0], val[1], [val[2]]) }
  ;

  Constant:
    CONSTANT                            { result = GetConstantNode.new(val[0]) }
  ;

  # assignment to a variable or constant
  Assign:
    IDENTIFIER "=" Expression           { result = SetLocalNode.new(val[0], val[2]) }
  | CONSTANT "=" Expression             { result = SetConstantNode.new(val[0], val[2]) }
  ;

  # method definition
  Def:
    DEF IDENTIFIER Block                { result = DefNode.new(val[1], [], val[2]) }
  | DEF IDENTIFIER
      "(" ParamList ")" Block           { result = DefNode.new(val[1], val[3], val[5]) }
  ;

  ParamList:
    /* nothing */                       { result = [] }
  | IDENTIFIER                          { result = val }
  | ParamList "," IDENTIFIER            { result = val[0] << val[2] }
  ;

  # class definition
  Class:
    CLASS CONSTANT Block                { result = ClassNode.new(val[1], val[2]) }
  ;

  # if block
  If:
    IF Expression Block                 { result = IfNode.new(val[1], val[2]) }
  ;

  # block of indented code - hard work is done by the lexer
  Block:
    INDENT Expression DEDENT            { result = val[1] }
  ;
end

---- header
  require "lexer"
  require "nodes"

---- inner
  # this code will be put as-is in the Parser class
  def parse(code, show_tokens = false)
    @tokens = Lexer.new.tokenize(code) # tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # kickoff the parsing process
  end