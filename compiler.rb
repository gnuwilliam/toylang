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
end

# initial header to initialize the module
def preamble
  define_external_functions
end

def finish
  @builder.ret(LLVM::Int(0))
end
