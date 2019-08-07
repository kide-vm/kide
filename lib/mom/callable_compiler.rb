module Mom

  # CallableCompiler is used to generate mom instructions. It is an abstact base
  # class shared by BlockCompiler and MethodCompiler

  # - mom_instructions: The sequence of mom level instructions that mom was compiled to
  #                 Instructions derive from class Instruction and form a linked list

  class CallableCompiler

    def initialize( callable )
      @callable = callable
      @constants = []
      @block_compilers = []
      @mom_instructions = Label.new(source_name, source_name)
      @current = start = @mom_instructions
      add_code Label.new( source_name, "return_label")
      add_code Mom::ReturnSequence.new(source_name)
      add_code Label.new( source_name, "unreachable")
      @current = start
    end
    attr_reader :mom_instructions , :constants , :block_compilers , :callable , :current

    def return_label
      @mom_instructions.each do |ins|
        next unless ins.is_a?(Label)
        return ins if ins.name == "return_label"
      end
    end

    # add a constant (which get created during compilation and need to be linked)
    def add_constant(const)
      raise "Must be Parfait #{const}" unless const.is_a?(Parfait::Object)
      @constants << const
    end

    # add a risc instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add_code( instruction )
      raise "Not an instruction:#{instruction.to_s}:#{instruction.class.name}" unless  instruction.is_a?(Mom::Instruction)
      new_current = instruction.last #after insertion this point is lost
      @current.insert(instruction) #insert after current
      @current = new_current
      self
    end

    # resolve the type of the slot, by inferring from it's name, using the type
    # scope related slots are resolved by the compiler by method/block
    def slot_type( slot , type)
      case slot
      when :frame
        new_type = self.frame_type
      when :arguments
        new_type = self.arg_type
      when :receiver
        new_type = self.receiver_type
      when Symbol
        new_type = type.type_for(slot)
        raise "Not found object #{slot}: in #{type}" unless new_type
      else
        raise "Not implemented object #{slot}:#{slot.class}"
      end
      #puts "RESOLVE in #{@type.class_name} #{slot}->#{type}"
      return new_type
    end

    # return the frame type, ie the blocks frame type
    def frame_type
      @callable.frame_type
    end

    # return the frame type, ie the blocks arguments type
    def arg_type
      @callable.arguments_type
    end
    # return the frame type, ie the blocks self_type
    def receiver_type
      @callable.self_type
    end

  end
end
