# represents an Toy object instance in the Ruby world
class ToyObject
  attr_acessor :runtime, :ruby_value

  # each object have a class (named runtime_class to prevent errors with Ruby's class method)
  # optionaly an object can hold a Ruby value (eg.: numbers and strings)
end
