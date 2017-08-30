module Mom

  # Base class for MOM instructions
  class Instruction
  end

  # basically a label
  class Noop
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
