# boostrap the runtime
# assemble all classes and objects together from the runtime

toy_class = ToyClass.new  				# Class
toy_class.runtime_class = toy_class  	# Class.class = Class
object_class = ToyClass.new 			# Object = Class.new