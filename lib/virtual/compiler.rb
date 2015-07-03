module Virtual
  module Compiler

    # Compiling is the conversion of the AST into 2 things:
    # - code (ie sequences of Instructions inside Blocks) carried by MethodSource
    # - an object graph containing all the Methods, their classes and Constants
    #
    # Some compile methods just add code, some may add structure (ie Blocks) while
    # others instantiate Class and Method objects
    #
    # Everything in ruby is an expression, ie returns a value. So the effect of every compile
    # is that a value is put into the ReturnSlot of the current Message.
    # The compile method (so every compile method) returns the value that it deposits which
    # may be unknown Unknown value.
    #
    # The Compiler.compile uses a visitor patter to dispatch according to the class name of
    # the expression. So a NameExpression is delegated to compile_name etc.
    # This makes the dispatch extensible, ie Expressions may be added by external code,
    # as long as matching compile methods are supplied too.
    #
    def self.compile expression , method
      exp_name = expression.class.name.split("::").last.sub("Expression","").downcase
      #puts "Expression #{exp_name}"
      begin
        self.send "compile_#{exp_name}".to_sym , expression, method
      rescue NoMethodError => e
        puts "No compile method found for " + exp_name
        raise e
      end
    end

  end
end

require_relative "compiler/basic_expressions"
require_relative "compiler/callsite_expression"
require_relative "compiler/compound_expressions"
require_relative "compiler/if_expression"
require_relative "compiler/function_expression"
require_relative "compiler/module_expression"
require_relative "compiler/operator_expressions"
require_relative "compiler/return_expression"
require_relative "compiler/while_expression"
require_relative "compiler/expression_list"
