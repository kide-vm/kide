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
      @name = name.to_sym
      @args = Array.new(args.length)
      args.each_with_index do |arg , i|
        if arg.is_a?(Value)
          @args[i] = arg
          raise "arg in non std register #{arg.inspect}" unless (i+1) == arg.register
        else
          @args[i] = arg.new(i+1)
        end
      end
      set_return return_type
      @exit =  Core::Kernel::function_exit( Vm::Block.new("#{name}_exit" , self) , name )
      @return =  Block.new("#{name}_return", self , @exit)
      @body =  Block.new("#{name}_body", self , @return)
      @entry = Core::Kernel::function_entry( Vm::Block.new("#{name}_entry" , self , @body) ,name )
      @locals = []
      @blocks = []
    end

    attr_reader :args , :entry , :exit , :body , :name , :return_type

    def set_return type_or_value
      @return_type = type_or_value || Vm::Integer 
      if @return_type.is_a?(Value)
        raise "return in non std register #{@return_type.inspect}" unless 7 == @return_type.register
      else
        @return_type = @return_type.new(7)
      end
    end
    def arity
      @args.length
    end

    def new_local type = Vm::Integer
      register = args.length + @locals.length
      l = type.new(register + 1) # one for the type register 0, TODO add type as arg0 implicitly
      raise "the red flag #{inspect}" if l.register > 6
      @locals << l
      l
    end

    def save_locals context , into
      save = args.collect{|a| a.register } + @locals.collect{|l| l.register}
      into.push(save) unless save.empty?
    end

    def restore_locals context , into
      #TODO assumes allocation in order, as the pop must be get regs in ascending order (also push)
      restore = args.collect{|a| a.register } + @locals.collect{|l| l.register}
      into.pop(restore) unless restore.empty?
    end

    def new_block name
      block = Block.new(name , self)
      @blocks << block
      block
    end

    # return a list of the blocks that are addressable, ie entry and @blocks and all next
    def blocks
      ret = []
      (@blocks << @entry).each do |b|
        while b
          ret << b
          b = b.next
        end  
      end
      ret
    end
    # following id the Code interface
    
    # to link we link the entry and then any blocks. The entry links the straight line
    def link_at address , context
      super #just sets the position
      @entry.link_at address , context
      address += @entry.length
      @blocks.each do |block|
        block.link_at(pos , context)
        pos += block.length
      end
    end

    # position of the function is the position of the entry block
    def position
      @entry.position
    end

    # length of a function is the entry block length (includes the straight line behind it) 
    # plus any out of line blocks that have been added
    def length
      @blocks.inject(@entry.length) {| sum  , item | sum + item.length}
    end
    
    # assembling assembles the entry (straight line/ no branch line) + any additional branches
    def assemble io
      @entry.assemble(io)
      @blocks.each do |block|
        block.assemble io
      end
    end

  end
end