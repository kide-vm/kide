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
  
  # Programs are created by invoking methods on subclasses of Value. 
  # But executable code is a sequence of Instructions and subclasses.
  
  # A Machines main responsibility in the framework is to instantiate Instruction
  # Value functions are mapped to machines by concatenating the values class name + the methd name
  # Example:  SignedValue.plus( value ) ->  Machine.signed_plus (value )
  
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

    def self.instance
      @@instance
    end
    def self.instance= machine
      @@instance = machine
    end
  end
end
