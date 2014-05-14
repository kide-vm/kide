require_relative 'helper'

# test the generation of a whole program
# not many asserts, but assume all is  well (ho ho)
# linking and running does not produce seqmentation fault, ie it works
# should really thiink about more asserts (but currently no way to execute as still running on mac )
#    (have to fix the int being used in code generation as ruby int is only 31 bits, and that wont do)

class TestSmallProg < MiniTest::Test
  # need a code generator, for arm 
  def setup
    @program = Vm::Program.new "Arm"
  end

  def test_loop
    @program.main.instance_eval do
      mov :left => :r0, :right => 5                #1
      start = Vm::Block.new("start")
      add_code start
      start.instance_eval do
        sub :left => :r0, :right => :r0, :extra => 1 , :update_status_flag => 1      #2
        bne :left => start           #3
      end
    end
    write( 6 , "loop" )
  end

  def test_hello
    hello = Vm::StringConstant.new "Hello Raisa\n"
    @program.add_object hello
    @program.main.instance_eval do 
      mov :left =>:r7, :right => 4     # 4 == write
      mov :left =>:r0 , :right => 1    # stdout
      add :left =>:r1 , :extra => hello   # address of "hello Raisa"
      mov :left =>:r2 , :right => hello.length
    	swi :left => 0         #software interupt, ie kernel syscall
    end
    write(7 + hello.length/4 + 1 , 'hello') 
  end

  #helper to write the file
  def write len ,name
    writer = Elf::ObjectWriter.new(Elf::Constants::TARGET_ARM)
    io = @program.assemble(StringIO.new)
    assembly = io.string
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
