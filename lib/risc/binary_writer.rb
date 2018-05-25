module Risc
  # Little glue class to get the assembled binary from the Arm Instructions into
  # the BinaryCode instances. Arm code originally uses io, but slightly modified
  # really only uses write_unsigned_int_32 , which converts
  # to an set_internal_word on the BinaryCode
  #
  # Machine instantiates and the writer reads from the arm Instructions
  # and writes to the BinaryCode
  class BinaryWriter
    def initialize( code )
      @code = code
    end

    # Go through and assemble all instructions.
    def assemble( instruction )
      @index = 0
      while(instruction)
        instruction.assemble(self)
        instruction = instruction.next
      end
    end

    def write_unsigned_int_32( bin )
      @code.set_word( @index , bin )
      @index += 1
    end
  end

  #even less glue to get that last jump in there.
  # So instructions don't run into the BinaryCode object header 
  class JumpWriter
    def initialize( code )
      @code = code
    end
    def write_unsigned_int_32( bin )
      @code.set_word( 14 , bin )
    end
  end
end
