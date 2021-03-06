# boostrap the runtime
# assemble all classes and objects together from the runtime

toy_class = ToyClass.new                # Class
toy_class.runtime_class = toy_class     # Class.class = Class
object_class = ToyClass.new             # Object = Class.new
object_class.runtime_class = toy_class  # Object.class = Class

# create the Runtime object (the root context) on which all code starts its evaluation
Runtime = Context.new(object_class.new)

Runtime["Class"] = toy_class
Runtime["Object"] = object_class
Runtime["Number"] = ToyClass.new
Runtime["String"] = ToyClass.new

# inherited class
Runtime["Number"] = ToyClass.new(Runtime["Object"])

# everything is an object in the language, even true, false and nil
# they need to have a class too
Runtime["TrueClass"] = ToyClass.new
Runtime["FalseClass"] = ToyClass.new
Runtime["NilClass"] = ToyClass.new

Runtime["true"] = Runtime["TrueClass"].new_with_value(true)
Runtime["false"] = Runtime["FalseClass"].new_with_value(true)
Runtime["nil"] = Runtime["NilClass"].new_with_value(true)

# add `new` method to classes, used to instantiate a class:
# eg.: Object.new, Number.new, String.new
Runtime["Class"].runtime_methods["new"] = proc do |receiver, arguments|
  receiver.new
end

# print an object to the console
# eg.: print("hi there!")
Runtime["Object"].runtime_methods["print"] = proc do |receiver, arguments|
  puts arguments.first.ruby_value
  Runtime["nil"]
end

Runtime["Number"].runtime_methods["+"] = proc do |receiver,arguments|
  result = receiver.ruby_value + arguments.first.ruby_value
  Runtime["Number"].new_with_value(result)
end