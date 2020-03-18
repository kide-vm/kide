module Risc

  # Transfer the constents of one register to another.
  # possibly called move in some cpus

  # There are other instructions to move data from / to memory, namely SlotToReg and RegToSlot

  # Get/Set Slot move data around in vm objects, but transfer moves the objects (in the machine)
  #
  # Also it is used for moving temorary data
  #

  class Transfer < Instruction
    # initialize with from and to registers.
    # First argument from
    # second argument to
    #
    # Note: this may be reversed from some assembler notations (also arm)
    def initialize( source , from , to )
      super(source)
      @from = from
      @to = to
      raise "Fix me #{from}" unless from.is_a? RegisterValue
      raise "Fix me #{to}" unless to.is_a? RegisterValue
    end
    attr_reader :from, :to

    # return an array of names of registers that is used by the instruction
    def register_names
      [from.symbol , to.symbol]
    end

    def to_s
      class_source "#{from} -> #{to}"
    end
  end
  def self.transfer( source , from , to)
    Transfer.new( source , from , to)
  end
end
