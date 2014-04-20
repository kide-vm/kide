require_relative 'helper'
require "asm/arm/code_generator"

# try  to test that the generation of basic instructions works
# one instruction at a time, reverse testing from objdump --demangle -Sfghxp
# tests are named as per assembler code, ie test_mov testing mov instruction
#  adc add and bic eor orr rsb rsc sbc sub mov mvn cmn cmp teq tst b bl bx swi strb

class TestSmallProg < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  def test_generate_small
    @generator.instance_eval {
      mov r0, 5                #1
      loop_start = label
      loop_start.set!
      subs r0, r0, 1          #2
      bne loop_start          #3
    	mov r7, 1               #4
    	swi 0                   #5  5 instruction x 4 == 20
    }

    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble
    assert_equal 20 , assembly.length 
    writer.set_text assembly
    writer.save('small_test.o')    
  end
end
