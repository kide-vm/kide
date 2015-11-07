module Soml
  # Compiling is the conversion of the AST into 2 things:
  # - code (ie sequences of Instructions inside Methods)
  # - an object graph containing all the Methods, their classes and Constants
  #
  # Some compile methods just add code, some may add Instructions while
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
  # A compiler can also be used to generate code for a method without AST nodes. In the same way
  # compile methods do, ie adding Instructions etc. In this way code may be generated that
  # has no code equivalent.
  #
  # The Compiler also keeps a list of used registers, from which one may take to use and return to
  # when done. The list may be reset.
  #
  # The Compiler also carries method and class instance variables. The method is where code is
  # added to (with add_code). To be more precise, the @current instruction is where code is added
  # to, and that may be changed with set_current

  # All Statements reset the registers and return nil.
  # Expressions use registers and return the register where their value is stored.

  # Helper function to create a new compiler and compie the statement(s)
  def self.compile statement
    compiler = Compiler.new
    compiler.process statement
  end

  class Compiler < AST::Processor

    def initialize( method = nil )
      @regs = []
      return unless method
      @method = method
      @clazz = method.for_class
      @current = method.instructions
    end
    attr_reader :clazz , :method

    def handler_missing node
      raise "No handler  on_#{node.type}(node)"
    end

    # create the method, do some checks and set it as the current method to be added to
    # class_name and method_name are pretty clear, args are given as a ruby array
    def create_method( class_name , method_name , args)
      raise "create_method #{class_name}.#{class_name.class}" unless class_name.is_a? Symbol
      clazz = Register.machine.space.get_class_by_name class_name
      raise "No such class #{class_name}" unless clazz
      create_method_for( clazz , method_name , args)
    end

    # create a method for the given class ( Parfait class object)
    # method_name is a Symbol
    # args a ruby array
    # the created method is set as the current and the given class too
    # return the compiler (for chaining)
    def create_method_for clazz , method_name , args
      @clazz = clazz
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a? Symbol
      arguments = []
      args.each_with_index do | arg , index |
        unless arg.is_a? Parfait::Variable
          arg = Parfait::Variable.new arg , "arg#{index}".to_sym
        end
        arguments << arg
      end
      @method = clazz.create_instance_method( method_name , Register.new_list(arguments))
      self
    end

    # add method entry and exit code. Mainly save_return for the enter and
    # message shuffle and FunctionReturn for the return
    # return self for chaining
    def init_method
      source = "_init_method"
      @method.instructions = Register::Label.new(source, "#{method.for_class.name}.#{method.name}")
      @current = enter = method.instructions
      add_code Register::Label.new( source, "return")
      # move the current message to new_message
      add_code  Register::RegisterTransfer.new(source, Register.message_reg , Register.new_message_reg )
      # and restore the message from saved value in new_message
      add_code Register.get_slot("_init_method_",:new_message , :caller , :message )
      #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
      add_code Register::FunctionReturn.new( source , Register.new_message_reg , Register.resolve_index(:message , :return_address) )
      @current = enter
      self
    end

    # set the insertion point (where code is added with add_code)
    def set_current c
      @current = c
    end

    # add an instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add_code instruction
      unless  instruction.is_a?(Register::Instruction)
        raise instruction.to_s
      end
      @current.insert(instruction) #insert after current
      @current = instruction
      self
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

    # ensure the name given is not space and raise exception otherwise
    # return the name for chaining
    def no_space name
      raise "space is a reserved name" if name == :space
      name
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
