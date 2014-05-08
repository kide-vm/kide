require 'intel/instruction'

module Intel
  ##
  # Operand is any kind of operand used in a command or instruction,
  # eg: registers, memory addresses, labels, immediates, etc.

  class Operand
    attr_accessor :machine, :bits

    def initialize machine = nil , bits = nil
      @bits = bits
      @machine = machine
    end

    def method_missing msg, *args, &b
      ok = Instruction.new( [msg, self, *args] + (b ? [b] : []) , machine).assemble
      return super unless ok 
      ok
    end

    def operand?
      true
    end
  end

end