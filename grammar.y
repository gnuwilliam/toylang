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
end