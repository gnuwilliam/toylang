require "rubygems"
require "parser"
require "nodes"

require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/scalar'
require 'llvm/transforms/ipo'

LLVM.init_x86

# compiler is used in a similar way as the runtime
# but instead of executing code, it will generate LLVM byte-code
# for later execution
class Compiler
  # initialize llvm types
  PCHAR = LLVM::Type.pointer(LLVM::Int8) # equivalent to *char in C
  INT   = LLVM::Int # equivalent to int in C

  attr_reader :locals

  def initialize(mod = nil, function = nil)
    # create the LLVM module in which to store the code
    @module = mod || LLVM::Module.create("toy")

    # to track local names during compilation
    @locals = {}

    # function in which the code will be put
    @function = function ||
      # by default, create a main function as it's the std entry point
      @module.functions.named("main") ||
      @module.functions.add("main", [INT, LLVM::Type.pointer(PCHAR)], INT)

    # create an LLVM byte-code builder
    @builder = LLVM::Builder.create
    @builder.position_at_end(@function.basic_blocks.append)

    @engine = LLVM::ExecutionEngine.create_jit_compiler(@module)
  end

  # initial header to initialize the module
  def preamble
    define_external_functions
  end

  def finish
    @builder.ret(LLVM::Int(0))
  end

  # create a new string
  def new_string(value)
    @builder.global_string_pointer(value)
  end

  # create a new number
  def new_number(value)
    LLVM::Int(value)
  end

  # call a function
  def call(func, args = [])
    f = @module.functions.named(func)
    @builder.call(f, *args)
  end

  # assign a local variable
  def assign(name, value)
    # allocate the memory and returns a pointer to it
    ptr = @builder.alloca(value.type)

    # store the value inside the pointer
    @builder.store(value, ptr)

    # keep track of the pointer so the compiler can find it back later
    @locals[name] = ptr
  end

  # load value of a local variable
  def load(value)
    @builder.load(@locals[name])
  end

  # defines a function
  def function(name)
    func = @module.functions.add(name, [], INT)
    generator = Compiler.new(@module, func)
    yield generator
    generator.finish
  end

  # optmize the generated LLVM byte-code
  def optimize
    @module.verify!
    pass_manager = LLVM::PassManager.new(@engine)
    pass_manager.simplifycfg! # simplify the CFG
    pass_manager.mem2reg!     # promote memory to register
    pass_manager.gdce!        # dead global elimination
  end

  # JIT compile and run the LLVM byte-code
  def run
    @engine.run_function(@function, 0, 0)
  end
end
