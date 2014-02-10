# represents a method defined in the runtime
class ToyMethod
  def initialize(params, body)
    @params = params
    @body = body
  end

  def call(receiver, arguments)
    # create a context of evaluation in which the method will execute
    context = Context.new(receiver)

    # assign arguments to local variables
    @params.each_with_index do |param, index|
      context.locals[param] = arguments[index]
    end
  end
end