module Phisol
  class Compiler < AST::Processor

    def initialize()
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
    # Everything in ruby is an statement, ie returns a value. So the effect of every compile
    # is that a value is put into the ReturnSlot of the current Message.
    # The compile method (so every compile method) returns the value that it deposits.
    #
    # The process uses a visitor pattern (from AST::Processor) to dispatch according to the
    # type the statement. So a s(:if xx) will become an on_if(node) call.
    # This makes the dispatch extensible, ie Expressions may be added by external code,
    # as long as matching compile methods are supplied too.
    #
    def self.compile statement
      compiler = Compiler.new
      compiler.process statement
    end

  end
end

require_relative "ast_helper"
require_relative "compiler/basic_values"
require_relative "compiler/call_site"
require_relative "compiler/class_field"
require_relative "compiler/collections"
require_relative "compiler/statement_list"
require_relative "compiler/field_def"
require_relative "compiler/field_access"
require_relative "compiler/function_definition"
require_relative "compiler/if_statement"
require_relative "compiler/class_statement"
require_relative "compiler/name_expression"
require_relative "compiler/operator_value"
require_relative "compiler/return_statement"
require_relative "compiler/while_statement"
