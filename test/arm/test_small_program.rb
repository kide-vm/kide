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
      mov  :r0,  5                #1
      start = Vm::Block.new("start")
      add_code start
      start.instance_eval do
        sub  :r0, :r0, 1 , :update_status => 1      #2
        bne  start  ,{}         #3
      end
    end
    @should = [0,176,160,227,5,0,160,227,1,0,80,226,253,255,255,26,1,112,160,227,0,0,0,239]
    write( 6 , "loop" )
  end

  def test_hello
    hello = Vm::StringConstant.new "Hello Raisa\n"
    @program.add_object hello
    @program.main.instance_eval do 
      mov :r7,  4     # 4 == write
      mov :r0 ,  1    # stdout
      add :r1 , hello , nil   # address of "hello Raisa"
      mov :r2 ,  hello.length
    	swi  0          #software interupt, ie kernel syscall
    end
    @should = [0,176,160,227,4,112,160,227,1,0,160,227,12,16,143,226,16,32,160,227,0,0,0,239,1,112,160,227,0,0,0,239,72,101,108,108,111,32,82,97,105,115,97,10,0,0,0,0]
    write "hello"
  end

  # a hand coded version of the fibonachi numbers (moved to kernel to be able to call it)
  #  not my hand off course, found in the net from a basic introduction
  def test_fibo
    int = Vm::Integer.new(1) # the one is funny, but the fibo is _really_ tight code and reuses registers
    fibo  = @program.get_or_create_function(:fibo)
    @program.main.mov( int , 10 )
    @program.main.call( fibo )
    # this is the version without the putint (which makes the program 3 times bigger)
    @should = [0,176,160,227,10,16,160,227,1,0,0,235,1,112,160,227,0,0,0,239,0,64,45,233,1,0,81,227,1,0,160,209,14,240,160,209,28,64,45,233,1,48,160,227,0,64,160,227,2,32,65,226,4,48,131,224,4,64,67,224,1,32,82,226,251,255,255,90,3,0,160,225,28,128,189,232,0,128,189,232]
    #putint = @program.get_or_create_function(:putint)
    #@program.main.call( putint )
    # so here the "full" version with putint
    @should_b = [0,176,160,227,10,16,160,227,2,0,0,235,33,0,0,235,1,112,160,227,0,0,0,239,0,64,45,233,1,0,81,227,1,0,160,209,14,240,160,209,28,64,45,233,1,48,160,227,0,64,160,227,2,32,65,226,4,48,131,224,4,64,67,224,1,32,82,226,251,255,255,90,3,0,160,225,28,128,189,232,0,128,189,232,0,64,45,233,10,32,65,226,33,17,65,224,33,18,129,224,33,20,129,224,33,24,129,224,161,17,160,225,1,49,129,224,131,32,82,224,1,16,129,82,10,32,130,66,48,32,130,226,0,32,192,229,1,0,64,226,0,0,81,227,239,255,255,27,0,128,189,232,0,64,45,233,0,16,160,225,36,0,143,226,9,0,128,226,233,255,255,235,24,0,143,226,12,16,160,227,1,32,160,225,0,16,160,225,1,0,160,227,4,112,160,227,0,0,0,239,0,128,189,232,32,32,32,32,32,32,32,32,32,32,32,0]
    write "fibo"
  end

  #helper to write the file
  def write name
    writer = Elf::ObjectWriter.new(@program , Elf::Constants::TARGET_ARM)
    assembly = writer.text
    puts assembly
    assembly.text.bytes.each_with_index do |byte , index|
      assert_equal  byte , @should[index] , "byte #{index}"
    end
#    writer.save("#{name}_test.o")
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
