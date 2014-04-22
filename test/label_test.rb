require_relative 'helper'

#try to call an extern function

class TestExtern < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::ArmAssembler.new
  end

  def test_extern
    @generator.instance_eval {
      mov r7, 4 #4 == write
      mov r0 , 1     #stdout
      add r1 , pc , 12   # address of "hello Raisa"
      mov r2 , 12 # length of hello
    	swi 0
      mov r7, 1   #1 == exit
    	swi 0
    }
    @generator.add_data("Hello Raisa"+ "\n\x00")
    write(7 , 'label') 
  end
  #helper to write the file
  def write len ,name
    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble_to_string
    #assert_equal len * 4 , assembly.length 
    writer.set_text assembly
    writer.save("#{name}_test.o")    
  end
end
# _start copied from dietc
#  	mov	fp, #0			@ clear the frame pointer
#  	ldr	a1, [sp]		@ argc
#  	add	a2, sp, #4		@ argv
#  	ldr	ip, .L3
#  	add	a3, a2, a1, lsl #2	@ &argv[argc]
#  	add	a3, a3, #4		@ envp	
#  	str	a3, [ip, #0]		@ environ = envp
#  	bl	main
