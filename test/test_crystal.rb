require_relative 'helper'
require "asm/arm/code_generator"

# try  to test that the generation of basic instructions works
# one instruction at a time, reverse testing from objdump --demangle -Sfghxp
# tests are named as per assembler code, ie test_mov testing mov instruction

class TestArmAsm < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  # code is what the generator spits out, at least one instruction worth (.first)
  # the op code is wat was witten as assembler in the first place and the binary result
  # is reversed and in 4 bytes as ruby can only do 31 bits and so we can't test with just one int (?)
  def assert_code code , op , should
    assert_equal op ,  code.opcode
    binary = @generator.assemble
    assert_equal 4 , binary.length
    index = 0
    binary.each_byte do |byte |
      assert_equal should[index] , byte 
      index += 1
    end
  end
  def test_mov
    code = @generator.instance_eval { mov r0, 5 }.first
    assert_code code , :mov , [0x05,0x00,0xa0,0xe3]
    assert ! code.affect_status #no s at the end, silly for mov anyway
  end
  def test_sub
    code = @generator.instance_eval { subs r2, r0, 1 }.first
    assert_code code, :sub ,  [0x01,0x20,0x50,0xe2]
    assert code.affect_status #the s at the end
  end

  def saved_other
    @generator.instance_eval do
      mov r0, 5
      loop_start = label
      loop_start.set!
      subs r0, r0, 1
      bne loop_start
      bx lr
    end
  end
end
