require "ast/sexp"
require_relative "compile_helper"

module Risc
  module Builtin
    class Space
      module ClassMethods
        include AST::Sexp
        include CompileHelper

        # main entry point, ie __init__ calls this
        # defined here as empty, to be redefined
        def main context
          compiler = compiler_for(:Space , :main ,{args: :Integer})
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
