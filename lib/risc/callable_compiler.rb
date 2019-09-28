module Risc

  # CallableCompiler is used to generate risc instructions. It is an abstact base
  # class shared by BlockCompiler and MethodCompiler

  # - risc_instructions: The sequence of risc level instructions that mom was compiled to
  #                 Instructions derive from class Instruction and form a linked list
  # - constants is an array of Parfait objects that need to be available
  # - callable is a Method of Block
  # - current instruction is where addidion happens
  #
  class CallableCompiler
    include Util::CompilerList

    # Must pass the callable (method/block)
    # Also start instuction, usually a label is mandatory
    def initialize( callable  , mom_label)
      raise "No method" unless callable
      @callable = callable
      @regs = []
      @constants = []
      @current = @risc_instructions = mom_label.risc_label(self)
      reset_regs
    end
    attr_reader :risc_instructions , :constants , :callable , :current

    def return_label
      @risc_instructions.each do |ins|
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
      raise "Not an instruction:#{instruction.to_s}:#{instruction.class.name}" unless  instruction.is_a?(Risc::Instruction)
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
    def build(source , &block)
      builder(source).build(&block)
    end

    # return a Builder, that adds the generated code to this compiler
    def builder( source)
      Builder.new(self , source)
    end

    # compile the callable (method or block) to cpu
    # return an Assembler that will then translate to binary
    def translate_cpu(translator)
      risc = @risc_instructions
      cpu_instructions = risc.to_cpu(translator)
      nekst = risc.next
      while(nekst)
        cpu = nekst.to_cpu(translator) # returning nil means no replace
        cpu_instructions << cpu if cpu
        nekst = nekst.next
      end
      Risc::Assembler.new(@callable , cpu_instructions )
    end

    # translate this method, which means the method itself and all blocks inside it
    # returns the array (of assemblers) that you pass in as collection
    def translate_method(  translator , collection)
      collection << translate_cpu( translator )
      collection
    end

  end
end
