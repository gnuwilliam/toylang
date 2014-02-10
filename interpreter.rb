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

class CallNode
  def eval(context)
    # if there's no receiver and the method name is the name of a local variable
    # then it's a local variable access
    # this trick allows us to skip the () when calling a method
    if receiver.nil? && context.locals[method] && arguments.empty?
      context.locals[method]

    # method call
    else
      if receiver
        value = receiver.eval(context)
      else
        # in case there's no receiver, default to self, calling "print" is like
        # "self.print"
        value = context.current_self
      end

      eval_arguments = arguments.map { |arg| arg.eval(context) }
      value.call(method, eval_arguments)
    end
  end
end

class GetConstantNode
  def eval(context)
    context[name]
  end
end

class SetConstantNode
  def eval(context)
    context[name] = value.eval(context)
  end
end

class SetLocalNode
  def eval(context)
    context.locals[name] = value.eval(context)
  end
end

class DefNode
  def eval(context)
    # defining a method is adding a method to the current class
    method = ToyMethod.new(params, body)
    context.current_class.runtime_methods[name] = method
  end
end

class ClassNode
  def eval(context)
    # try to locate the class. allows reopening classes to add methods
    awesome_class = context[name]

    unless toy_class # class does not exist yet
      toy_class = ToyClass.new
      # register the class as a constant in the runtime
      context[name] = toy_class
    end

    # evaluate the body of the class in its context
    # providing a custom context allows to control 
    # where methods are added when defined with the def keyword
    # in this case, we add them to the newly created class
    class_context = Context.new(toy_class, toy_class)
  end
end