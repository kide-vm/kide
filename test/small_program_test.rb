require_relative 'helper'

# test the generation of a whole program
# not many asserts, but assume all is  well (ho ho)
# linking and running does not produce seqmentation fault, ie it works
# moving on to calling external functions to get some output

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
