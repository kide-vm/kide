require_relative 'helper'

# test the generation of a whole program
# not many asserts, but assume all is  well (ho ho)
# linking and running does not produce seqmentation fault, ie it works
# should really thiink about more asserts (but currently no way to execute as still running on mac )
#    (have to fix the int being used in code generation as ruby int is only 31 bits, and that wont do)

class TestSmallProg < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @generator = Asm::Arm::ArmAssembler.new
  end

  def test_loop
    @generator.instance_eval {
      mov r0, 5                #1
      loop_start = label!
      subs r0, r0, 1          #2
      bne loop_start          #3
    	mov r7, 1               #4
    	swi 0                   #5  5 instructions
    }
    write( 5 , "loop" )
  end

  def test_hello
    hello = "Hello Raisa"+ "\n\x00"
    @generator.instance_eval {
      mov r7, 4     # 4 == write
      mov r0 , 1    # stdout
      add r1 , pc , hello   # address of "hello Raisa"
      mov r2 , hello.length
    	swi 0         #software interupt, ie kernel syscall
      mov r7, 1     # 1 == exit
    	swi 0
    }
    write(7 , 'label') 
  end

  #test dropped along with functionality, didn't work and not needed (yet?) TODO
  def no_test_extern
    @generator.instance_eval {
      mov r0 , 50             #1
      push lr                 #2
      bl extern(:putchar)     #3
    	pop pc                  #4 
      mov r7, 1               #5
    	swi 0                   #6  6 instructions
    }
    #this actually seems to get an extern symbol out there and linker is ok (but doesnt run, hmm)
    @generator.relocations.each { |reloc|
      #puts "reloc #{reloc.inspect}"
      writer.add_reloc_symbol reloc.label.name.to_s
    }
    write( 6 , "extern")
  end

  #helper to write the file
  def write len ,name
    writer = Asm::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    assembly = @generator.assemble_to_string
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
