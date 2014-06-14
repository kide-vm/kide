require_relative "block"
require_relative "passes"

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

    def initialize(name , receiver = Vm::Reference , args = [] , return_type = Vm::Reference)
      super()
      @name = name.to_sym
      if receiver.is_a?(Value)
        @receiver = receiver
        raise "arg in non std register #{receiver.inspect}" unless RegisterMachine.instance.receiver_register == receiver.register_symbol
      else
        puts receiver.inspect
        @receiver = receiver.new(RegisterMachine.instance.receiver_register)
      end
      
      @args = Array.new(args.length)
      args.each_with_index do |arg , i|
        shouldda = RegisterReference.new(RegisterMachine.instance.receiver_register).next_reg_use(i + 1)
        if arg.is_a?(Value)
          @args[i] = arg
          raise "arg #{i} in non std register #{arg.register}, expecting #{shouldda}" unless shouldda == arg.register
        else
          @args[i] = arg.new(shouldda)
        end
      end
      set_return return_type
      @exit =  RegisterMachine.instance.function_exit( Vm::Block.new("exit" , self , nil) , name )
      @return =  Block.new("return", self , @exit)
      @body =  Block.new("body", self , @return)
      @insert_at = @body
      @entry = RegisterMachine.instance.function_entry( Vm::Block.new("entry" , self , @body) ,name )
      @locals = []
    end

    attr_reader :args , :entry , :exit , :body , :name , :return_type , :receiver 
    
    def insertion_point
      @insert_at
    end
    def set_return type_or_value
      @return_type = type_or_value || Vm::Reference 
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
      register = args.length + 3 + @locals.length # three for the receiver, return and type regs
      l = type.new(register)     #so start at r3
      puts "new local #{l.register_symbol}"
      raise "Register overflow in function #{name}" if register >= 13 # yep, 13 is bad luck
      @locals << l
      l
    end
    
    # return a list of registers that are still in use after the given block
    # a call_site uses pushes and pops these to make them available for code after a call
    def locals_at l_block
      used =[]
      # call assigns the return register, but as it is in l_block, it is not asked.
      assigned = [ RegisterReference.new(Vm::RegisterMachine.instance.return_register) ]
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

    # when control structures create new blocks (with new_block) control continues at some new block the
    # the control structure creates. 
    # Example: while, needs  2 extra blocks
    #          1 condition code, must be its own blockas we jump back to it
    #           -       the body, can actually be after the condition as we don't need to jump there
    #          2 after while block. Condition jumps here 
    # After block 2, the function is linear again and the calling code does not need to know what happened
    
    # But subsequent statements are still using the original block (self) to add code to
    # So the while expression creates the extra blocks, adds them and the code and then "moves" the insertion point along
    def insert_at block
      @insert_at = block
      self
    end

    # create a new linear block after the current insertion block. 
    # Linear means there is no brach needed from that one to the new one. 
    # Usually the new one just serves as jump address for a control statement
    # In code generation (assembly) , new new_block is written after this one, ie zero runtime cost
    # This does _not_ change the insertion point, that has do be done with insert_at(block)
    def new_block new_name
      block_name = "#{@insert_at.name}_#{new_name}"
      new_b = Block.new( block_name , self , @insert_at.next )
      @insert_at.set_next new_b
      return new_b
    end

    def add_code(kode)
      raise "alarm #{kode}" if kode.is_a? Word
      raise "alarm #{kode.class} #{kode}" unless kode.is_a? Code
      @insert_at.do_add kode
      self
    end

    # sugar to create instructions easily. 
    # any method will be passed on to the RegisterMachine and the result added to the insertion block
    #  With this trick we can write what looks like assembler, 
    #  Example   func.instance_eval
    #                mov( r1 , r2 )
    #                add( r1 , r2 , 4)
    # end
    #           mov and add will be called on Machine and generate Inststuction that are then added 
    #             to the current block
    # also symbols are supported and wrapped as register usages (for bare metal programming)
    def method_missing(meth, *args, &block)
      add_code RegisterMachine.instance.send(meth , *args)
    end

    # following id the Code interface
    
    # to link we link the entry and then any blocks. The entry links the straight line
    def link_at address , context
      super #just sets the position
      @entry.link_at address , context
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