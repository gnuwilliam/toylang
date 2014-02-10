# boostrap the runtime
# assemble all classes and objects together from the runtime

toy_class = ToyClass.new  				# Class
toy_class.runtime_class = toy_class  	# Class.class = Class
object_class = ToyClass.new 			# Object = Class.new
object_class.runtime_class  			# Object.class = Class

# create the Runtime object (the root context) on which all code starts its evaluation
Runtime = Context.new(object_class.new)