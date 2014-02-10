# the evaluation context
class Context
  attr_reader :locals, :current_self, :current_class

  # store constants as class variable
  # class variables start with @@
  # instance variables start with @ in Ruby since they are globally accessible
  # implement namespacing of constants, you could store it in the instance of this class
  @@constants = {}

  def initialize(current_self, current_class = current_self.runtime_class)
    @locals = {}
    @current_self = current_self
    @current_class = current_class
  end

  # shortcuts to access constants, Runtime[...] instead of Runtime.constants[...]
  def [](name)
    @@constants[name]
  end

  def []=(name, value)
    @@constants[name] = value
  end
end