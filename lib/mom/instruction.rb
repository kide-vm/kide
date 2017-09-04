module Mom

  # Base class for MOM instructions
  class Instruction
    attr :next_instruction

    # flattening will change the structure from a tree to a linked list (and use
    # next_instruction to do so)
    def flatten
      raise "not implemented"
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
require_relative "if_statement"
require_relative "truth_check"
require_relative "jump"
require_relative "slot_load"
require_relative "return_sequence"
