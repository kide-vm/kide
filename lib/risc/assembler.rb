module Risc
  class Assembler
    attr_reader :method , :instructions

    def initialize( method , instructions)
      @method = method
      @instructions = instructions
      total = instructions.total_byte_length / 4 + 1
      method.binary.extend_to( total )
    end
  end
end
