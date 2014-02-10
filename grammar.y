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
end