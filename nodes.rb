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
