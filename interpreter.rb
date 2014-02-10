require "parser"
require "runtime"

class Interpreter
  def initialize
    @parser = Parser.new
  end

  def eval(code)
    @parser.parse(code).eval(Runtime)
  end
end

class Nodes
  # this method is the "interpreter" part of the language 
  # all nodes know how to eval # itself and returns the result
  # of its evaluation by implementing the "eval" method
  # the "context" variable is the environment in which the node is evaluated
  # local variables, current class, etc
end