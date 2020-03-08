module Risc

  # CallableCompiler is used to generate risc instructions. It is an abstact base
  # class shared by BlockCompiler and MethodCompiler

  # - risc_instructions: The sequence of risc level instructions that slot machine was
  #                     compiled to
  #                 Instructions derive from class Instruction and form a linked list
  # - constants is an array of Parfait objects that need to be available
  # - callable is a Method of Block
  # - current instruction is where addidion happens
  #
  class CallableCompiler
    include Util::CompilerList

    # Must pass the callable (method/block)
    # Also start instuction, usually a label is mandatory
    def initialize( callable  , slot_label)
      raise "No method" unless callable
      @callable = callable
      @allocator = Allocator.new
      @constants = []
      @current = @risc_instructions = slot_label.risc_label(self)
      @allocator.reset_regs
    end
    attr_reader :risc_instructions , :constants , :callable , :current

    # find the return label. Every methd should have exactly one
    def return_label
      @risc_instructions.each do |ins|
        next unless ins.is_a?(Label)
        return ins if ins.name == "return_label"
      end
    end

    # add a constant (which get created during compilation and need to be linked)
    # constants must be Parfait instances
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

    # Load a constant, meaning create a LoadConstant or LoadData instruction for the
    # given constant. Integers create LoadData (meaning the integer is encoded into
    # the actual instruction), Parfait::Objects create LoadConstant, where a pointer
    # to the object is loaded.
    # add the instruction to the code and return the register_value that was created
    # for further use
    # register may be passed in (epecially in mcro building) as second arg
    def load_object( object , into = nil)
      if(object.is_a? Integer)
        ins = Risc.load_data("load data #{object}" , object , into)
      else
        ins = Risc.load_constant("load to #{object}" , object , into)
      end
      ins.register.set_compiler(self)
      add_code ins
      # todo for constants (not objects)
      # add_constant(right) if compiler
      ins.register
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
require_relative "allocator"
