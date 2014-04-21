require_relative 'helper'

#try to call an extern function

class TestExtern < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::CodeGenerator.new
  end

  def test_extern
    @generator.instance_eval {
      push lr
      ldr r0, "hello world".to_sym
      mov r7, 4 #4 is write
    	swi 0                   
    	pop pc
      mov r7, 1   #1 == exit
    	swi 0
    }

    write(7 , 'label')    
  end
  #helper to write the file
  def write len ,name
    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble
    assert_equal len * 4 , assembly.length 
    writer.set_text assembly
    writer.save("#{name}_test.o")    
  end
end
