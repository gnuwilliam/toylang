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
  def eval(context)
    return_value = nil
    nodes.each do |node|
      return_value = node.eval(context)
    end
    # the last value evaluated in a method is the return value
    # or nil if none
    return_value || Runtime["nil"]
  end
end

class NumberNode
  def eval(context)
    # access the Runtime to create a new instance of the Number class
    Runtime["Number"].new_with_value(value)
  end
end

class StringNode
  def eval(context)
    Runtime["String"].new_with_value(value)
  end
end

class TrueNode
  def eval(context)
    Runtime["true"]
  end
end

class FalseNode
  def eval(context)
    Runtime["false"]
  end
end

class NilNode
  def eval(context)
    Runtime["nil"]
  end
end