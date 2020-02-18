module SlotMachine

  # A base class for conditions in SlotMachine
  # Checks (if in code, compare in assm) jump or not, depending
  # The logic we choose is closer to the code logic (the asm is reversed)
  # When we write an if, the true is the next code, so the Check logic is
  # that if the check passes, no jump happens
  # This means you need to pass the false label, where to jump to if the
  # check does not pass
  # Note: In assembler a branch on 0 does just that, it branches if the condition
  #       is met. This means that the asm implementation is somewhat the reverse
  #       of the SlotMachine names. But it's easier to understand (imho)
  class Check < Instruction
    attr_reader :false_label

    def initialize(false_label)
      set_label(false_label)
    end

    def set_label(false_label)
      @false_label = false_label
      raise "Jump target must be a label #{false_label}" unless false_label.is_a?(Label)    end
  end

end
