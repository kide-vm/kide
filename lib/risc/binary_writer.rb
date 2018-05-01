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
    # Assembly may cause LinkException, which is caught by caller
    def assemble( instruction )
      @index = 1
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

  # A LinkException is raised when the arm code can't fit a constant into _one_
  # instruction. This is kind of unavoidable with arm.
  #
  # Off course the problem could be fixed without the exception, but the exception
  # means all subsequent Instructions, including labels/jump targets move.
  # Thus changing jump instructions to those labels.
  # So the whole method has to be reassembled and (at least) the instructions beyond
  # repositioned. Ie a non-local problem, and so the Exception.
  #
  # Note: In the future i hope to have a more flexible system, possibly with position
  # listeners and change events. Because positions chaning is normal, not exceptional.
  #
  class LinkException < Exception
  end

end
