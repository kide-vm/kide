require_relative "block"

module Vm

  # Functions are similar to Blocks. Where Blocks can be jumped to, Functions can be called.

  # Functions also have arguments, though they are handled differently (in register allocation)
  
  # Functions have a exactly three blocks, entry, exit and body, which are created for you
  # with straight branches between them.

  # Also remember that if your den body exists of several blocks, they must be wrapped in a 
  # block as the function really only has the one, and blocks only assemble their codes,
  # not their next links
  # This comes at zero runtime cost though, as the wrapper is just the sum of it's codes
  
  # If you change the body block to point elsewhere, remember to end up at exit

  class Function < Code

    def initialize(name , args = [])
      super()
      @name = name
      @args = args
      @entry = Core::Kernel::function_entry( Vm::Block.new("#{name}_entry") ,name )
      @exit =  Core::Kernel::function_exit( Vm::Block.new("#{name}_exit") , name )
      @body =  Block.new("#{name}_body")
      @reg_count = 0
      branch_body
    end
    attr_reader :args , :entry , :exit , :body , :name
    attr_accessor :return_type

    def arity
      @args.length
    end

    def next_register
      next_free = @reg_count
      @reg_count += 1
      next_free + args.length
    end

    def link_at address , context
      raise "undefined code #{inspect}" if @body.nil? 
      super #just sets the position
      @entry.link_at address , context
      address += @entry.length
      @body.link_at(address , context)
      address += @body.length
      @exit.link_at(address,context)
    end
    
    def length
      @entry.length + @exit.length + @body.length
    end
    
    def assemble io
      @entry.assemble(io)
      @body.assemble(io)
      @exit.assemble(io)
    end

    private
    # set up the braches from entry to body and body to exit (unless that exists, see set_body)
    def branch_body
      @entry.set_next(@body)
      @body.set_next(@exit) if @body and  !@body.next
    end
  end
end