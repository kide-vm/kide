module Mom

  # Base class for MOM instructions
  class Instruction
    include Common::List

    # implement flatten as noop to avoid condition
    def flatten( options = {} )
      return self
    end
  end

  # A label with a name
  class Label < Instruction
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
