require_relative "block"

module Vm

  # Functions are similar to Blocks. Where Blocks can be jumped to, Functions can be called.

  # Functions also have arguments, though they are handled differently (in register allocation)
  
  # Functions have a minimum of two blocks, entry and exit, which are created for you
  # but there is no branch created between them, this must be done by the programmer.
  

  class Function < Block

    def initialize(name , args = [])
      super(name)
      @args = args
      @entry = Core::Kernel::function_entry( name )
      @exit = Core::Kernel::function_exit( name )
    end
    attr_reader :args , :entry , :exit
    
    def arity
      @args.length
    end

    def link_at address , context
#      function = context.program.get_function(name)
#      unless function
#        function = Core::Kernel.send(name)
#        context.program.get_or_create_function( name , function , arity )
#      end

      @entry.link_at address , context
      address += @entry.length
      super(address , context)
      address += @entry.length
      @exit.link_at(address,context)
    end
    
    def length
      @entry.length + @exit.length + super
    end
    
    def assemble io
      @entry.assemble io
      super(io)
      @exit.assemble(io)
    end

    private 
    def add_arg value
      # TODO check
      @args << value
    end
  end
end