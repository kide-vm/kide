module Mom

  # CallableCompiler is used to generate Mom instructions.

  # - mom_instructions: The sequence of mom level instructions that vool was compiled to

  class CallableCompiler

    def initialize( callable )
      @callable = callable
      @constants = []
      @block_compilers = []
      @mom_instructions = Risc.label(source_name, source_name)
      @current = start = @risc_instructions
      add_code Risc.label( source_name, "return_label")
      Mom::ReturnSequence.new.to_risc(self)
      add_code Risc.label( source_name, "unreachable")
      @current = start
    end
    attr_reader :risc_instructions , :constants , :block_compilers , :callable , :current

    def return_label
      @risc_instructions.each do |ins|
        next unless ins.is_a?(Label)
        return ins if ins.name == "return_label"
      end
    end

    # convert the given mom instruction to_risc and then add it (see add_code)
    # continue down the instruction chain unti depleted
    # (adding moves the insertion point so the whole mom chain is added as a risc chain)
    def add_mom( instruction )
      while( instruction )
        raise "whats this a #{instruction}" unless instruction.is_a?(Mom::Instruction)
        #puts "adding mom #{instruction.to_s}:#{instruction.next.to_s}"
        instruction.to_risc( self )
        reset_regs
        #puts "adding risc #{risc.to_s}:#{risc.next.to_s}"
        instruction = instruction.next
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
      raise "Not an instruction:#{instruction.to_s}:#{instruction.class.name}" unless  instruction.is_a?(Risc::Instruction)
      raise instruction.to_s if( instruction.class.name.split("::").first == "Arm")
      new_current = instruction.last #after insertion this point is lost
      @current.insert(instruction) #insert after current
      @current = new_current
      self
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
