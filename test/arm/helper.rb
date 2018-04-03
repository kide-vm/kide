require_relative "../helper"

# try  to test that the generation of basic instructions works
# one instruction at a time, reverse testing from objdump --demangle -Sfghxp
# tests are named as per assembler code, ie test_mov testing mov instruction

module Arm
  module ArmHelper
    def setup
      @machine = Arm::ArmMachine
    end

    # code is what the generator spits out, at least one instruction worth (.first)
    # the op code is wat was witten as assembler in the first place and the binary result
    def assert_code( code , op , should )
      assert_equal op ,  code.opcode
      io = StringIO.new
      code.assemble(io)
      binary = io.string
      assert_equal should.length , binary.length , "code length wrong for #{code.inspect}"
      index = 0
      binary.each_byte do |byte |
        assert_equal should[index] , byte , "byte #{index} 0x#{should[index].to_s(16)} != 0x#{byte.to_s(16)}"
        index += 1
      end
    end
  end
end
