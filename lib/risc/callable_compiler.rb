module Risc

  # CallableCompiler is used to generate risc instructions. It is an abstact base
  # class shared by BlockCompiler and MethodCompiler

  # - risc_instructions: The sequence of risc level instructions that mom was compiled to
  # - cpu_instructions: The sequence of cpu specific instructions that the
  #                      risc_instructions was compiled to
  #                 Instructions derive from class Instruction and form a linked list

  class CallableCompiler

    def initialize( )
      @regs = []
      @risc_instructions = Risc.label(source_name, source_name)
      @risc_instructions << Risc.label( source_name, "unreachable")
      @current = @risc_instructions
      @constants = []
      @block_compilers = []
    end
    attr_reader :risc_instructions , :constants , :block_compilers

    # convert the given mom instruction to_risc and then add it (see add_code)
    # continue down the instruction chain unti depleted
    # (adding moves the insertion point so the whole mom chain is added as a risc chain)
    def add_mom( instruction )
      while( instruction )
        raise "whats this a #{instruction}" unless instruction.is_a?(Mom::Instruction)
        #puts "adding mom #{instruction.to_s}:#{instruction.next.to_s}"
        risc = instruction.to_risc( self )
        add_code(risc)
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
      raise "Not an instruction:#{instruction.to_s}" unless  instruction.is_a?(Risc::Instruction)
      raise instruction.to_s if( instruction.class.name.split("::").first == "Arm")
      new_current = instruction.last #after insertion this point is lost
      @current.insert(instruction) #insert after current
      @current = new_current
      self
    end

    # require a (temporary) register. code must give this back with release_reg
    # Second extra parameter may give extra info about the value, see RegisterValue
    def use_reg( type , extra = {} )
      raise "Not type #{type.inspect}" unless type.is_a?(Symbol) or type.is_a?(Parfait::Type)
      if @regs.empty?
        reg = Risc.tmp_reg(type , extra)
      else
        reg = @regs.last.next_reg_use(type , extra)
      end
      @regs << reg
      return reg
    end

    # resolve the type of the slot, by inferring from it's name, using the type
    # scope related slots are resolved by the compiler by methood/block
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

    def copy( reg , source )
      copied = use_reg reg.type
      add_code Register.transfer( source , reg , copied )
      copied
    end

    # releasing a register (accuired by use_reg) makes it available for use again
    # thus avoiding possibly using too many registers
    def release_reg( reg )
      last = @regs.pop
      raise "released register in wrong order, expect #{last} but was #{reg}" if reg != last
    end

    # reset the registers to be used. Start at r4 for next usage.
    # Every statement starts with this, meaning each statement may use all registers, but none
    # get saved. Statements have affect on objects.
    def reset_regs
      @regs.clear
    end

    # Build with builder (see there), adding the created instructions
    def build(&block)
      builder.build(&block)
    end

    # return a new code builder that uses this compiler
    # CodeBuilder returns code after building
    def code_builder( source)
      CodeBuilder.new(self , source)
    end

    # return a CompilerBuilder
    # CompilerBuilder adds the generated code to the compiler
    def compiler_builder( source)
      CompilerBuilder.new(self , source)
    end
  end
end
