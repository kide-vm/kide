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

    # write into the given BinaryCode instance
    def assemble( instruction )
      @index = 1
      while(instruction)
        begin
          instruction.assemble(self)
        rescue LinkException
          instruction.assemble(self)
        end
        instruction = instruction.next
        puts "Next #{instruction.to_s}"
      end
    end

    def write_unsigned_int_32( bin )
      @code.set_word( @index , bin )
      @index += 1
    end
  end

end
