module Mom

  # Base class for MOM instructions
  class Instruction
    attr :next_instruction

    # implement flatten as noop to avoid condition
    def flatten
    end
  end

  # A label with a name
  class Label
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

end

require_relative "simple_call"
require_relative "truth_check"
require_relative "jump"
require_relative "slot_load"
require_relative "return_sequence"
require_relative "statement"
