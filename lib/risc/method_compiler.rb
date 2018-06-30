module Risc

  # MethodCompiler (old name) is used to generate risc instructions for methods
  # and to instantiate the methods correctly. Most of the init is typed layer stuff,
  # but there is some logic too.

  class MethodCompiler

    def initialize( method )
      @regs = []
      @method = method
      @current = @method.risc_instructions
    end
    attr_reader :method

    # helper method for builtin mainly
    # the class_name is a symbol, which is resolved to the instance_type of that class
    #
    # return compiler_for_type with the resolved type
    #
    def self.compiler_for_class( class_name , method_name , args , frame )
      raise "create_method #{class_name}.#{class_name.class}" unless class_name.is_a? Symbol
      clazz = Parfait.object_space.get_class_by_name! class_name
      compiler_for_type( clazz.instance_type , method_name , args , frame)
    end

    # create a method for the given type ( Parfait type object)
    # method_name is a Symbol
    # args a hash that will be converted to a type
    # the created method is set as the current and the given type too
    # return the compiler
    def self.compiler_for_type( type , method_name , args , frame)
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      raise "Args must be Type #{args}" unless args.is_a?(Parfait::Type)
      raise "create_method #{method_name}.#{method_name.class}" unless method_name.is_a? Symbol
      method = type.create_method( method_name , args , frame)
      self.new(method)
    end

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

    def add_constant(const)
      Risc.machine.add_constant(const)
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
    def use_reg( type , value = nil )
      raise "Not type #{type.inspect}" unless type.is_a?(Symbol) or type.is_a?(Parfait::Type)
      if @regs.empty?
        reg = Risc.tmp_reg(type , value)
      else
        reg = @regs.last.next_reg_use(type , value)
      end
      @regs << reg
      return reg
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
