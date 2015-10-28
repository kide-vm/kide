
module Register
  # the static info of a method (with its compiled code, argument names etc ) is part of the
  # runtime, ie found in Parfait::Method

  # Code-wise Methods are made up from a list of Instructions.

  # Instructions can be of three tyes:
  # -linear:  flow continues from one to the next as they are sequential both logically and
  #           "physically" use the set_next for this (or add_code).
  #           This "straight line", there must be a continuous sequence from body to return
  # - branched: Any of the Branch instructions creates a fork. The else branch is the "next"
  #             of a branch. The only valid branch targets are Labels.
  #

  class MethodSource

    # create method does two things
    # first it creates the parfait method, for the given class, with given argument names
    # second, it creates MethodSource and attaches it to the method
    #
    # compile code then works with the method, but adds code tot the info
    def self.create_method( class_name , method_name , args)
      raise "create_method #{class_name}.#{class_name.class}" unless class_name.is_a? Symbol
      clazz = Register.machine.space.get_class_by_name class_name
      raise "No such class #{class_name}" unless clazz
      create_method_for( clazz , method_name , args)
    end
    def self.create_method_for clazz , method_name , args
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a? Symbol
      arguments = []
      args.each_with_index do | arg , index |
        unless arg.is_a? Parfait::Variable
          arg = Parfait::Variable.new arg , "arg#{index}".to_sym
        end
        arguments << arg
      end
      method = clazz.create_instance_method( method_name , Register.new_list(arguments))
      method.source = MethodSource.new(method)
      method
    end
    # just passing the method object in for Instructions to make decisions (later)
    def initialize method
      init( method )
    end

    def init method
      @method = method
      method.instructions = Label.new(self, "#{method.for_class.name}_#{method.name}")
      @current = method.instructions
      add_code  enter = Register.save_return(self, :message , :return_address)
      add_code Label.new( method, "return")
      # move the current message to new_message
      add_code  RegisterTransfer.new(self, Register.message_reg , Register.new_message_reg )
      # and restore the message from saved value in new_message
      add_code Register.get_slot(self,:new_message , :caller , :message )
      #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
      add_code FunctionReturn.new( self , Register.new_message_reg , Register.resolve_index(:message , :return_address) )
      @current = enter
    end
    attr_accessor   :method

    def set_current c
      @current = c
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

    def total_byte_length
      @method.instructions.total_byte_length
    end

    # position of the function is the position of the entry block, is where we call
    def set_position at
      at += 8 #for the 2 header words
      @method.instructions.set_position at
    end

  end

end
