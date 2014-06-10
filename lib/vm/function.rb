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

    def initialize(name , receiver = Vm::Integer , args = [] , return_type = Vm::Integer)
      super()
      @name = name.to_sym
      if receiver.is_a?(Value)
        @receiver = receiver
        raise "arg in non std register #{receiver.inspect}" unless RegisterMachine.instance.receiver_register == receiver.register_symbol
      else
        @receiver = receiver.new(RegisterMachine.instance.receiver_register)
      end
      
      @args = Array.new(args.length)
      args.each_with_index do |arg , i|
        shouldda = RegisterUse.new(RegisterMachine.instance.receiver_register).next_reg_use(i + 1)
        if arg.is_a?(Value)
          @args[i] = arg
          raise "arg #{i} in non std register #{arg.used_register}, expecting #{shouldda}" unless shouldda == arg.used_register
        else
          @args[i] = arg.new(shouldda)
        end
      end
      set_return return_type
      @exit =  Core::Kernel::function_exit( Vm::Block.new("exit" , self , nil) , name )
      @return =  Block.new("return", self , @exit)
      @body =  Block.new("body", self , @return)
      @entry = Core::Kernel::function_entry( Vm::Block.new("entry" , self , @body) ,name )
      @locals = []
      @linked = false # incase link is called twice, we only calculate locals once
    end

    attr_reader :args , :entry , :exit , :body , :name , :return_type , :receiver

    def set_return type_or_value
      @return_type = type_or_value || Vm::Integer 
      if @return_type.is_a?(Value)
        raise "return in non std register #{@return_type.inspect}" unless RegisterMachine.instance.return_register == @return_type.register_symbol
      else
        @return_type = @return_type.new(RegisterMachine.instance.return_register)
      end
    end
    def arity
      @args.length
    end

    def new_local type = Vm::Integer
      register = args.length + 1 + @locals.length # one for the receiver implicit arg
      l = type.new(register + 1) # one for the type register 0, TODO add type as arg0 implicitly
      puts "new local #{l.register_symbol}"
#      raise "Register overflow in function #{name}" if l.register > 6
      @locals << l
      l
    end
    
    # return a list of registers that are still in use after the given block
    # a call_site uses pushes and pops these to make them available for code after a call
    def locals_at l_block
      used =[]
      assigned = []
      l_block.reachable.each do |b|
        b.uses.each {|u|
          (used << u) unless assigned.include?(u) 
        }
        assigned += b.assigns
      end
      used.uniq
    end

    # return a list of the blocks that are addressable, ie entry and @blocks and all next
    def blocks
      ret = []
      b = @entry
      while b
        ret << b
        b = b.next
      end  
      ret
    end

    # following id the Code interface
    
    # to link we link the entry and then any blocks. The entry links the straight line
    def link_at address , context
      super #just sets the position
      @entry.link_at address , context
      return if @linked
      @linked = true
      blocks.each do |b|
        if push = b.call_block?
          locals = locals_at b
          if(locals.empty?)
            puts "Empty #{b}"
          else
            puts "PUSH #{push}"
            push.set_registers(locals)
            pop = b.next.codes.first
            puts "POP #{pop}"
            pop.set_registers(locals)
          end
        end
      end
    end

    # position of the function is the position of the entry block
    def position
      @entry.position
    end

    # length of a function is the entry block length (includes the straight line behind it) 
    # plus any out of line blocks that have been added
    def length
      @entry.length
    end
    
    # assembling assembles the entry (straight line/ no branch line) + any additional branches
    def assemble io
      @entry.assemble(io)
    end
  end
end