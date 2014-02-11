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
end
