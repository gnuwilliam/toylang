# mimic Object.new in the language
object = Runtime["Object"].call("new")

assert_equal Runtime["Object"], object.runtime_class # assert object is an Object