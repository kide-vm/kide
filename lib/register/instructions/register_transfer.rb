module Register

  # transfer the constents of one register to another.
  # possibly called move in some cpus

  # There are other instructions to move data from / to memory, namely GetSlot and SetSlot

  # Get/Set Slot move data around in vm objects, but transfer moves the objects (in the machine)
  #
  # Also it is used for moving temorary data
  #

  class RegisterTransfer < Instruction
    # initialize with from and to registers.
    # First argument from
    # second arguemnt to
    #
    # Note: this may be reversed from some assembler notations (also arm) 
    def initialize from , to
      @from = wrap_register(from)
      @to = wrap_register(to)
    end
    attr_reader :from, :to
  end
end
