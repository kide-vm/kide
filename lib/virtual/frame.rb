module Virtual
  # A frame, or activation frame, represents a function call during calling. So not the static definition of the function
  # but the dynamic invokation of it.
  #
  # In a minimal c world this would be just the return address, but with exceptions and continuations things get more
  # complicated. How much more we shall see
  #
  # The current list comprises
  # - next normal instruction
  # - next exception instruction
  # - self (me)
  # - argument mappings
  # - local variable mapping
  class Frame
    def initialize
      
    end
    attr_reader :next_normal, :next_exception, :me, :argument_names
  end
end
