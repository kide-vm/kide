require "ast/sexp"

module Risc
  module Builtin
    class Space
      module ClassMethods
        include AST::Sexp

        # main entry point, ie __init__ calls this
        # defined here as empty, to be redefined
        def main context
          compiler = Vm::MethodCompiler.create_method(:Space , :main ).init_method
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end

require_relative "integer"
require_relative "object"
require_relative "kernel"
require_relative "word"
