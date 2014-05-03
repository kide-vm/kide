module Vm

  # Our virtual machine has a number of registers of a given size and uses a stack
  # So much so standard
  # But our machine is oo, meaning that the register contents is typed. 
  # Off course current hardware does not have that (a perceived issue), but for our machine we pretend.
  # So internally we have at least 8 word registers, one of which is used to keep track of types*
  # and any number of scratch registers
  # but externally it's all Values (see there)
  
  # * Note that register content is typed externally. Not as in mri, where int's are tagged. Floats can's
  #   be tagged and lambda should be it's own type, so tagging does not work
  
  # A Machines main responsibility in the framework is to instantiate Instruction

  # Value functions are mapped to machines by concatenating the values class name + the methd name
  # Example:  SignedValue.plus( value ) ->  Machine.signed_plus (value )
  
  # Also, shortcuts are created to easily instantiate Instruction objects. The "standard" set of instructions
  # (arm-influenced) provides for normal operations on a register machine, 
  # Example:  pop -> StackInstruction.new( {:opcode => :pop}.merge(options) )
  # Instructions work with options, so you can pass anything in, and the only thing the functions does
  # is save you typing the clazz.new. It passes the function name as the :opcode
   
  class Machine
  
    # hmm, not pretty but for now
    @@instance = nil
    
    attr_reader :registers
    attr_reader :scratch
    attr_reader :pc
    attr_reader :stack
    # is often a pseudo register (ie doesn't support move or other operations).
    # Still, using if to express tests makes sense, not just for 
    # consistency in this code, but also because that is what is actually done
    attr_reader :status  

    
    # here we create the shortcuts for the "standard" instructions, see above
    # Derived machines may use own instructions and define functions for them if so desired
    def initialize
      [:push, :pop].each do |inst|
        define_instruction(inst , StackInstruction)
      end

      [:adc, :add, :and, :bic, :eor, :orr, :rsb, :rsc, :sbc, :sub].each do |inst|
        define_instruction(inst , LogicInstruction)
      end
      [:mov, :mvn].each do |inst|
        define_instruction(inst , MoveInstruction)
      end
      [:cmn, :cmp, :teq, :tst].each do |inst|
        define_instruction(inst , CompareInstruction)
      end
      [:strb, :str , :ldrb, :ldr].each do |inst|
        define_instruction(inst , MemoryInstruction)
      end
      [:b, :bl , :swi].each do |inst|
        define_instruction(inst , CallInstruction)
      end
  
    end

    def create_method(name,  &block)
        self.class.send(:define_method, name , &block)
    end

    def define_instruction(inst , clazz )
      c_name = clazz.name
      my_module = self.class.name.split("::").first
      clazz_name = clazz.name.split("::").last
      if(my_module != Vm )
        module_class = eval("#{my_module}::#{clazz_name}") rescue nil
        clazz = module_class if module_class
      end
      create_method(inst) do |options|
        options = {} if options == nil
        options[:opcode] = inst
        clazz.new(options)
      end
    end

    def self.instance
      @@instance
    end
    def self.instance= machine
      @@instance = machine
    end
  end
end
