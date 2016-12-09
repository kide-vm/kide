require_relative "tree"

module Typed

  CompilerModules = [ "assignment" , "basic_values" , "call_site", "class_field" ,
                       "class_statement" , "collections" , "field_def" , "field_access",
                       "function_statement" , "if_statement" , "name_expression" ,
                       "operator_expression"]

  CompilerModules.each do |mod|
    require_relative "compiler/" + mod
  end

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
    code = Typed.ast_to_code statement
    compiler.process code
  end

  class Compiler
    CompilerModules.each do |mod|
      include Typed.const_get( mod.camelize )
    end

    def initialize( method = nil )
      @regs = []
      return unless method
      @method = method
      @clazz = method.for_class
      @current = method.instructions
    end
    attr_reader :clazz , :method


    # Dispatches `code` according to it's class name, for class NameExpression
    # a method named `on_NameExpression` is invoked with one argument, the `code`
    #
    # @param  [Typed::Code, nil] code
    def process(code)
      name = code.class.name.split("::").last
      # Invoke a specific handler
      on_handler = :"on_#{name}"
      if respond_to? on_handler
        return send on_handler, code
      else
        raise "No handler  on_#{name}(code) #{code.inspect}"
      end
    end

    # {#process}es each code from `codes` and returns an array of
    # results.
    #
    def process_all(codes)
      codes.to_a.map do |code|
        process code
      end
    end

    def on_Statements(codes)
      process_all codes.statements
    end

    # create the method, do some checks and set it as the current method to be added to
    # class_name and method_name are pretty clear, args are given as a ruby array
    def create_method( class_name , method_name , args = {})
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
      if( args.is_a? Array)
        arguments = args
      else
        args.each do | name , type |
          arguments << Parfait::Variable.new( type , name.to_sym)
        end
      end
      @method = clazz.create_instance_method( method_name , Parfait.new_list(arguments))
      self
    end

    # add method entry and exit code. Mainly save_return for the enter and
    # message shuffle and FunctionReturn for the return
    # return self for chaining
    def init_method
      source = "_init_method"
      name = "#{method.for_class.name}.#{method.name}"
      @method.instructions = Register::Label.new(source, name)
      @current = enter = method.instructions
      add_code Register::Label.new( source, "return #{name}")
      #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
      add_code Register::FunctionReturn.new( source , Register.message_reg , Register.resolve_index(:message , :return_address) )
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

    def copy reg , source
      copied = use_reg reg.type
      add_code Reister.transfer source , reg , copied
      copied
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

require_relative "compiler/return_statement"
require_relative "compiler/statement_list"
require_relative "compiler/while_statement"
