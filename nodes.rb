# collection of nodes each one representing an expression
class Nodes < Struct.new(:nodes)
  def <<(node)
    nodes << node
    self
  end
end

# literals are static values that have a Ruby representation, eg.: a string, a number,
# true, false, nil, etc
class LiteralNode < Struct.new(:value); end
class NumberNode < LiteralNode; end
class StringNode < LiteralNode; end
class TrueNode < LiteralNode
  def initialize
    super(true)
  end
end
class FalseNode < LiteralNode
  def initialize
    super(false)
  end
end
class NilNode < LiteralNode
  def initialize
    super(nil)
  end
end

# node of a method call or local variable access, can take any of these forms:
# 
#   method # this form can also be a local variable
#   method(argument1, argument2)
#   receiver.method
#   receiver.method(argument1, argument2)
#
class CallNode < Struct.new(:receiver, :method, :arguments); end

# retrieving the value of a constant
class GetConstantNode < Struct.new(:name); end

# setting the value of a constant
class SetConstantNode < Struct.new(:name, :value); end

# setting the value of a local variable
class SetLocalNode < Struct.new(:name, :value); end

# method definition
class DefNode < Struct.new(:name, :params, :body); end

