# collection of nodes each one representing an expression
class Nodes < Struct.new(:nodes)
  def <<(node)
    nodes << node
    self
  end
end