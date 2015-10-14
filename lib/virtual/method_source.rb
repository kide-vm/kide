require_relative "block"

module Virtual
  # the static info of a method (with its compiled code, argument names etc ) is part of the
  # runtime, ie found in Parfait::Method

  # the source we create here is injected into the method and used only at compile-time

  #
  # Methods are one step up from to VM::Blocks. Where Blocks can be jumped to, Methods can be called.

  # Methods also have arguments and a return. These are typed by subclass instances of Value

  # They also have local variables.

  # Code-wise Methods are made up from a list of Blocks, in a similar way blocks are made up of
  # Instructions. The function starts with one block, and that has a start and end (return)

  # Blocks can be linked in two ways:
  # -linear:  flow continues from one to the next as they are sequential both logically and
  #           "physically" use the block set_next for this.
  #           This "straight line", there must be a continuous sequence from body to return
  #           Linear blocks may be created from an existing block with new_block
  # - branched: You create new blocks using function.new_block which gets added "after" return
  #            These (eg if/while) blocks may themselves have linear blocks ,but the last of these
  #            MUST have an uncoditional branch. And remember, all roads lead to return.

  class MethodSource

    # create method does two things
    # first it creates the parfait method, for the given class, with given argument names
    # second, it creates MethodSource and attaches it to the method
    #
    # compile code then works with the method, but adds code tot the info
    def self.create_method( class_name , return_type , method_name , args)
      raise "create_method #{class_name}.#{class_name.class}" unless class_name.is_a? Symbol
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a? Symbol
      clazz = Virtual.machine.space.get_class_by_name class_name
      raise "No such class #{class_name}" unless clazz
      arguments = []
      args.each_with_index do | arg , index |
        unless arg.is_a? Parfait::Variable
          raise "not type #{arg}:#{arg.class}" unless Virtual.machine.space.get_class_by_name arg
          arg = Parfait::Variable.new arg , "arg#{index}".to_sym
        end
        arguments << arg
      end
      method = clazz.create_instance_method( method_name , Virtual.new_list(arguments))
      method.source = MethodSource.new(method , return_type)
      method
    end
    # just passing the method object in for Instructions to make decisions (later)
    def initialize method , return_type
      init( method , return_type)
    end

    def init method , return_type = nil
      # first block we have to create with .new , as new_block assumes a current
      enter = Block.new( "enter"  , method ).add_code(MethodEnter.new( method ))
      set_return_type( return_type )
      @blocks = [enter]
      @current = enter
      new_block("return").add_code(MethodReturn.new(method))
      @constants = []
    end
    attr_reader   :blocks , :constants , :return_type
    attr_accessor  :current , :receiver

    def set_return_type type
      return if type.nil?
      raise "not type #{type}" unless Virtual.machine.space.get_class_by_name type
      @return_type = type
    end
    # add an instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add_code instruction
      unless (instruction.is_a?(Instruction) or instruction.is_a?(Register::Instruction))
        raise instruction.to_s
      end
      @current.add_code(instruction) #insert after current
      self
    end

    # return a list of registers that are still in use after the given block
    # a call_site uses pushes and pops these to make them available for code after a call
    def locals_at l_block
      used =[]
      # call assigns the return register, but as it is in l_block, it is not asked.
      assigned = [ Register::RegisterValue.new(Virtual::RegisterMachine.instance.return_register) ]
      l_block.reachable.each do |b|
        b.uses.each {|u|
          (used << u) unless assigned.include?(u)
        }
        assigned += b.assigns
      end
      used.uniq
    end

    # control structures need to see blocks as a graph, but they are stored as a list with implict
    # branches
    # So when creating a new block (with new_block), it is only added to the list, but instructions
    #   still go to the current one
    # With this function one can change the current block, to actually code it.
    # This juggling is (unfortunately) neccessary, as all compile functions just keep puring their
    # code into the method and don't care what other compiles (like if's) do.

    # Example: while, needs  2 extra blocks
    #          1 condition code, must be its own blockas we jump back to it
    #           -       the body, can actually be after the condition as we don't need to jump there
    #          2 after while block. Condition jumps here
    # After block 2, the function is linear again and the calling code does not need to know what
    #  happened

    # But subsequent statements are still using the original block (self) to add code to
    # So the while statement creates the extra blocks, adds them and the code and then "moves"
    # the insertion point along
    def current block
      @current = block
      self
    end

    # create a new linear block after the current insertion block.
    # Linear means there is no brach needed from that one to the new one.
    # Usually the new one just serves as jump address for a control statement
    # In code generation , the new_block is written after this one, ie zero runtime cost
    # This does _not_ change the insertion point, that has do be done with insert_at(block)
    def new_block new_name
      new_b = Block.new( new_name , @blocks.first.method )
      index = @blocks.index( @current )
      @blocks.insert( index + 1 , new_b ) # + one because we want the ne after the insert_at
      return new_b
    end

    # sugar to create instructions easily.
    # any method will be passed on to the RegisterMachine and the result added to the insertion block
    #  With this trick we can write what looks like assembler,
    #  Example   func.instance_eval
    #                mov( r1 , r2 )
    #                add( r1 , r2 , 4)
    # end
    #           mov and add will be called on Machine and generate Instructions that are then added
    #             to the current block
    # also symbols are supported and wrapped as register usages (for bare metal programming)
#    def method_missing(meth, *arguments, &block)
#      add_code ::Arm::ArmMachine.send(meth , *arguments)
#    end

    def byte_length
      @blocks.inject(0) { |c , block| c += block.byte_length }
    end

    # position of the function is the position of the entry block, is where we call
    def set_position at
      at += 8 #for the 2 header words
      @blocks.each do |block|
        block.set_position at
        at = at + block.byte_length
      end
    end

  end

end
