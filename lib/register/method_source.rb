
module Register
  # the static info of a method (with its compiled code, argument names etc ) is part of the
  # runtime, ie found in Parfait::Method

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
      clazz = Register.machine.space.get_class_by_name class_name
      raise "No such class #{class_name}" unless clazz
      arguments = []
      args.each_with_index do | arg , index |
        unless arg.is_a? Parfait::Variable
          raise "not type #{arg}:#{arg.class}" unless Register.machine.space.get_class_by_name arg
          arg = Parfait::Variable.new arg , "arg#{index}".to_sym
        end
        arguments << arg
      end
      method = clazz.create_instance_method( method_name , Register.new_list(arguments))
      method.source = MethodSource.new(method , return_type)
      method
    end
    # just passing the method object in for Instructions to make decisions (later)
    def initialize method , return_type
      init( method , return_type)
    end

    def init method , return_type = nil
      set_return_type( return_type )
      @instructions = @current = Label.new(self, "Method_#{method.name}")
      add_code  enter = Register.save_return(self, :message , :return_address)
      add_code Label.new( method, "return")
      # move the current message to new_message
      add_code  RegisterTransfer.new(self, Register.message_reg , Register.new_message_reg )
      # and restore the message from saved value in new_message
      add_code Register.get_slot(self,:new_message , :caller , :message )
      #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
      add_code FunctionReturn.new( self , Register.new_message_reg , Register.resolve_index(:message , :return_address) )
      @current = enter
      @constants = []
    end
    attr_reader    :constants , :return_type
    attr_accessor  :current , :receiver , :instructions

    def set_return_type type
      return if type.nil?
      raise "not type #{type}" unless Register.machine.space.get_class_by_name type
      @return_type = type
    end
    # add an instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add_code instruction
      unless  instruction.is_a?(Instruction)
        raise instruction.to_s
      end
      @current.insert(instruction) #insert after current
      @current = instruction
      self
    end

    # set the insertion point (where code is added with add_code)
    def current ins
      @current = ins
      self
    end

    def byte_length
      @instructions.total_byte_length
    end

    # position of the function is the position of the entry block, is where we call
    def set_position at
      at += 8 #for the 2 header words
      @instructions.set_position at
    end

  end

end
