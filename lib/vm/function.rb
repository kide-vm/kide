require_relative "block"

module Vm

  # Functions are similar to Blocks. Where Blocks can be jumped to, Functions can be called.

  # Functions also have arguments and a return. These are Value subclass instances, ie specify
  #   type (by class type) and register by instance

  # Functions have a exactly three blocks, entry, exit and body, which are created for you
  # with straight branches between them.

  # Also remember that if your body exists of several blocks, they must be wrapped in a 
  # block as the function really only has the one, and blocks only assemble their codes,
  # not their next links
  # This comes at zero runtime cost though, as the wrapper is just the sum of it's codes
  
  # If you change the body block to point elsewhere, remember to end up at exit

  class Function < Code

    def initialize(name , args = [] , return_type = nil)
      super()
      @name = name
      @args = Array.new(args.length)
      args.each_with_index do |arg , i|
        if arg.is_a?(Value)
          @args[i] = arg
          raise "arg in non std register #{arg.inspect}" unless i == arg.register
        else
          @args[i] = arg.new(i)
        end
      end
     @return_type = return_type || Vm::Integer 
     if @return_type.is_a?(Value)
       raise "return in non std register #{@return_type.inspect}" unless 0 == @return_type.register
     else
       @return_type = @return_type.new(0)
     end
     @entry = Core::Kernel::function_entry( Vm::Block.new("#{name}_entry" , self) ,name )
     @exit =  Core::Kernel::function_exit( Vm::Block.new("#{name}_exit", self) , name )
     @body =  Block.new("#{name}_body", self)
     @locals = []
     branch_body
    end
    attr_reader :args , :entry , :exit , :body , :name
    attr_accessor :return_type

    def arity
      @args.length
    end

    def new_local type = Vm::Integer
      register = args.length + @locals.length
      l = type.new(register)
      @locals << l
      l
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
    def position
      @entry.position
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