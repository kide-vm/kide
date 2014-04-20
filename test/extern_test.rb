require_relative 'helper'

#try to call an extern function

class TestExtern < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  def test_generate_small
    @generator.instance_eval {
      ldr r0, "hello world"   #1
      bl :printf              #2
    	mov r7, 1               #3
    	swi 0                   #4  4 instruction x 4 == 16
    }

    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble
    assert_equal 20 , assembly.length 
    writer.set_text assembly
    writer.save('small_test.o')    
  end
end
