# represents a Toy class in the Ruby world. classes are objects in Toy so they
# inherit from ToyObject
class ToyClass < ToyObject
  attr_reader = :runtime_methods

  # creates a new class. number is an instance of class for example
  def initialize
    @runtime_methods = {}

    # check if we're bootstraping (launching the runtime)
    # during this process, the runtime is not fully initialized
    # and core classes do not yet exists
    # so we defer using those once the language is bootstrapped
    # this solves the chicken-or-the-egg problem with the Class class
    # we can initialize Class then set Class.class = Class
    if defined?(Runtime)
      runtime_class = Runtime["Class"]
    else
      runtime_class = nil
    end
  end
end