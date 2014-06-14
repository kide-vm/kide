module Vm
  # Word is an abstract base class for the obvious values, ie those that fit into a register
  # Marked as abstract by private constructor
  #
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Mystery Value has unknown type and has only casting methods. So it must be cast to be useful.
  # Types are stored at runtime when needed in TYPE_REGISTER (r1 on arm), which is mostly before calls, 
  # so that the called function can do casts / branching correctly
  class Word < Value
    attr_accessor :register
    def register_symbol
      @register.symbol
    end
    def inspect
      "#{self.class.name} (#{register_symbol})"
    end
    def to_s
      inspect
    end
    def length
      4
    end
    # aka to string
    def to_asm
      "#{register_symbol}"
    end
    private 
    def initialize reg
      if reg.is_a? RegisterReference
        @register = reg
      else
        @register = RegisterReference.new(reg)
      end
    end
  end
end