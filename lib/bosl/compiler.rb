module Bosl
  class Compiler < AST::Processor
    attr_reader :method

    def initialize(method)
      @method = method
    end
    def handler_missing node
      raise "No handler  on_#{node.type}(node)"
    end
    # Compiling is the conversion of the AST into 2 things:
    # - code (ie sequences of Instructions inside Blocks) carried by MethodSource
    # - an object graph containing all the Methods, their classes and Constants
    #
    # Some compile methods just add code, some may add structure (ie Blocks) while
    # others instantiate Class and Method objects
    #
    # Everything in ruby is an expression, ie returns a value. So the effect of every compile
    # is that a value is put into the ReturnSlot of the current Message.
    # The compile method (so every compile method) returns the value that it deposits.
    #
    # The process uses a visitor pattern (from AST::Processor) to dispatch according to the
    # type the expression. So a s(:if xx) will become an on_if(node) call.
    # This makes the dispatch extensible, ie Expressions may be added by external code,
    # as long as matching compile methods are supplied too.
    #
    def self.compile expression , method
      compiler = Compiler.new method
      compiler.process expression
    end

  end
end

require_relative "ast_helper"
require_relative "compiler/basic_expressions"
require_relative "compiler/callsite_expression"
require_relative "compiler/class_field"
require_relative "compiler/compound_expressions"
require_relative "compiler/expression_list"
require_relative "compiler/field_def"
require_relative "compiler/field_access"
require_relative "compiler/function_expression"
require_relative "compiler/if_expression"
require_relative "compiler/module_expression"
require_relative "compiler/name_expression"
require_relative "compiler/operator_expressions"
require_relative "compiler/return_expression"
require_relative "compiler/while_expression"
