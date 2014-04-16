require_relative 'helper'
require "asm/arm/code_generator"

# try  to test that the generation of basic instructions works
class TestAsm < MiniTest::Test
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  def test_mov
    m = @generator.instance_eval { mov r0, 5 }.first
    assert_equal :mov ,  m.opcode
    binary = @generator.assemble
    assert_equal 4 , binary.length
    should = [0x05,0x00,0xa0,0xe3]
    index = 0
    binary.each_byte do |byte |
      assert_equal byte , should[index]
      index += 1
    end
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
