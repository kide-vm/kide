module Soml
  class Compiler < AST::Processor

    def initialize()
      @regs = []
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

    # simple helper to add the given code to the current method (instance variable)
    def add_code code
      @method.source.add_code code
    end
    # require a (temporary) register. code must give this back with release_reg
    def use_reg type , value = nil
      if @regs.empty?
        reg = Register.tmp_reg(type , value)
      else
        reg = @regs.last.next_reg_use(type , value)
      end
      @regs << reg
      return reg
    end

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg reg
      last = @regs.pop
      raise "released register in wrong order, expect #{last} but was #{reg}" if reg != last
    end

    # reset the registers to be used. Start at r4 for next usage.
    # Every statement starts with this, meaning each statement may use all registers, but none
    # get saved. Statements have affect on objects.
    def reset_regs
      @regs.clear
    end
  end
end

require_relative "ast_helper"
require_relative "compiler/assignment"
require_relative "compiler/basic_values"
require_relative "compiler/call_site"
require_relative "compiler/class_field"
require_relative "compiler/class_statement"
require_relative "compiler/collections"
require_relative "compiler/field_def"
require_relative "compiler/field_access"
require_relative "compiler/function_definition"
require_relative "compiler/if_statement"
require_relative "compiler/name_expression"
require_relative "compiler/operator_value"
require_relative "compiler/return_statement"
require_relative "compiler/statement_list"
require_relative "compiler/while_statement"
