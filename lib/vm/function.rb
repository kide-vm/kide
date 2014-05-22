require_relative "block"

module Vm

  # Functions are similar to Blocks. Where Blocks can be jumped to, Functions can be called.

  # Functions also have arguments and a return. These are Value subclass instances, ie specify
  #   type (by class type) and register by instance

  # They also have local variables. Args take up the first n regs, then locals the rest. No 
  #  direct manipulating of registers (ie specifying the number) should be done.

  # Code-wise Functions are made up from a list of Blocks, in a similar way blocks are made up of codes
  # Four of the block have a special role:
  # - entry/exit: are usually system specific
  # - body:  the logical start of the function
  # - return: the logical end, where ALL blocks must end
  
  # Blocks can be linked in two ways:
  # -linear:  flow continues from one to the next as they are sequential both logically and "physically"
  #           use the block set_next for this. 
  #           This "the straight line", there must be a continuous sequence from body to return
  #           Linear blocks may be created from an existing block with new_block
  # - branched: You create new blocks using function.new_block which gets added "after" return
  #            These (eg if/while) blocks may themselves have linear blocks ,but the last of these 
  #            MUST have an uncoditional branch. And remember, all roads lead to return.
  
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
     @exit =  Core::Kernel::function_exit( Vm::Block.new("#{name}_exit" , self) , name )
     @return =  Block.new("#{name}_return", self , @exit)
     @body =  Block.new("#{name}_body", self , @return)
     @entry = Core::Kernel::function_entry( Vm::Block.new("#{name}_entry" , self , @body) ,name )
     @locals = []
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
    end
    def position
      @entry.position
    end
    def length
      @entry.length
    end
    
    def assemble io
      @entry.assemble(io)
    end

  end
end