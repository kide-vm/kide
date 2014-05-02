require_relative 'helper'

# test the generation of a whole program
# not many asserts, but assume all is  well (ho ho)
# linking and running does not produce seqmentation fault, ie it works
# should really thiink about more asserts (but currently no way to execute as still running on mac )
#    (have to fix the int being used in code generation as ruby int is only 31 bits, and that wont do)

class TestSmallProg < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @program = Asm::Assembler.new
  end

  def test_loop
    @program.main do
      mov r0, 5                #1
      start do
        subs r0, r0, 1       #2
        bne :start           #3
        mov r7, 1               #4
      	swi 0                   #5  5 instructions
      end
    end
    write( 5 , "loop" )
  end

  def test_hello
    hello = "Hello Raisa\n"
    @program.main do 
      mov r7, 4     # 4 == write
      mov r0 , 1    # stdout
      add r1 , pc , hello   # address of "hello Raisa"
      mov r2 , hello.length
    	swi 0         #software interupt, ie kernel syscall
      mov r7, 1     # 1 == exit
    	swi 0
    end
    write(7 + hello.length/4 + 1 , 'hello') 
  end

  #helper to write the file
  def write len ,name
    writer = Elf::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @program.assemble_to_string
    assert_equal len * 4 , assembly.length 
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
