module Risc
  class Assembler
    attr_reader :callable , :instructions

    def initialize( callable , instructions)
      @callable = callable
      @instructions = instructions
      total = instructions.total_byte_length / 4 + 1
      callable.binary.extend_to( total )
    end
  end
end
