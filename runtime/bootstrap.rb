# boostrap the runtime
# assemble all classes and objects together from the runtime

toy_class = ToyClass.new  				# Class
toy_class.runtime_class = toy_class  	# Class.class = Class
object_class = ToyClass.new 			# Object = Class.new
object_class.runtime_class  			# Object.class = Class

# create the Runtime object (the root context) on which all code starts its evaluation
Runtime = Context.new(object_class.new)

Runtime["Class"] = toy_class
Runtime["Object"] = object_class
Runtime["Number"] = ToyClass.new
Runtime["String"] = ToyClass.new

# everything is an object in the language, even true, false and nil
# they need to have a class too
Runtime["TrueClass"] = ToyClass.new
Runtime["FalseClass"] = ToyClass.new
Runtime["NilClass"] = ToyClass.new

Runtime["true"] = Runtime["TrueClass"].new_with_value(true)