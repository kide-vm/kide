require_relative "block"

module Vm

  # Functions are similar to Blocks. Where Blocks can be jumped to, Functions can be called.

  # Functions also have arguments, though they are handled differently (in register allocation)
  
  # Functions have a minimum of two blocks, entry and exit, which are created for you
  # but there is no branch created between them, this must be done by the programmer.
  

  class Function < Value

    def initialize(name , args = [])
      super()
      @name = name
      @args = args
      @entry = Block.new("entry_#{name}")
      @exit = Block.new("exit_#{name}")
    end
    attr_reader :name , :args , :entry , :exit
    
    def arity
      @args.length
    end

    def compile function_expression ,  context
      arguments = function_expression.args.collect do |arg|
        add_arg arg.to_value
      end
      function = context.program.get_function(name)
      unless function
        function = Vm::Kernel.send(name)
        context.program.get_or_create_function( name , function , arity )
      end
    end
    
    def verify
      @entry.verify
      @exit.verify
    end

    private 
    def add_arg value
      # TODO check
      @args << value
    end
  end
end