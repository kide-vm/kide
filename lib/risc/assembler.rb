module Risc
  class Assembler
    attr_reader :method , :instructions , :constants
    def initialize( method , instructions, constants)
      @method = method
      @instructions = instructions
      @constants = constants
      total = instructions.total_byte_length / 4 + 1
      method.binary.extend_to( total )
    end
  end
end
