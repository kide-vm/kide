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
    s = Vm::Block.new("start",nil).scope binding
    m = @program.main.scope binding
    r0 = Vm::Integer.new(0)
    m.r0 = 5                #1
    m << s
    s.r0 = (r0 - 1).set_update_status      #2
    s.bne  s          #3
    @should = [0x0,0xb0,0xa0,0xe3,0x5,0x0,0xa0,0xe3,0x1,0x0,0x50,0xe2,0xfd,0xff,0xff,0x1a,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef]
    write "loop"
  end

  def test_hello
    hello = Vm::StringConstant.new "Hello Raisa\n"
    @program.add_object hello
    # these are only here because it's a test program, usually all coding happens with values
    r0 = Vm::Integer.new(0)
    r1 = Vm::Integer.new(1)
    r2 = Vm::Integer.new(2)
    r7 = Vm::Integer.new(7)
    b = @program.main.scope binding
    b.r7 = 4     # 4 == write
    b.r0 = 1    # stdout
    b.r1 = hello  # address of "hello Raisa"
    b.r2 =  hello.length
    b.swi  0          #software interupt, ie kernel syscall
    @should = [0x0,0xb0,0xa0,0xe3,0x4,0x70,0xa0,0xe3,0x1,0x0,0xa0,0xe3,0xc,0x10,0x8f,0xe2,0x10,0x20,0xa0,0xe3,0x0,0x0,0x0,0xef,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x48,0x65,0x6c,0x6c,0x6f,0x20,0x52,0x61,0x69,0x73,0x61,0xa,0x0,0x0,0x0,0x0]
    write "hello"
  end

  # a hand coded version of the fibonachi numbers (moved to kernel to be able to call it)
  #  not my hand off course, found in the net from a basic introduction
  def test_fibo
    int = Vm::Integer.new(1) # the one is funny, but the fibo is _really_ tight code and reuses registers
    fibo  = @program.get_or_create_function(:fibo)
    main= @program.main.scope binding
    main.int = 10
    main.call( fibo )
    # this is the version without the putint (which makes the program 3 times bigger)
    @should = [0x0,0xb0,0xa0,0xe3,0xa,0x10,0xa0,0xe3,0x1,0x0,0x0,0xeb,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x40,0x2d,0xe9,0x1,0x0,0x51,0xe3,0x1,0x0,0xa0,0xd1,0xe,0xf0,0xa0,0xd1,0x1c,0x40,0x2d,0xe9,0x1,0x30,0xa0,0xe3,0x0,0x40,0xa0,0xe3,0x2,0x20,0x41,0xe2,0x4,0x30,0x83,0xe0,0x4,0x40,0x43,0xe0,0x1,0x20,0x52,0xe2,0xfb,0xff,0xff,0x5a,0x3,0x0,0xa0,0xe1,0x1c,0x80,0xbd,0xe8,0x0,0x80,0xbd,0xe8]
    putint = @program.get_or_create_function(:putint)
    @program.main.call( putint )
    # so here the "full" version with putint
    @should = [0,176,160,227,10,16,160,227,2,0,0,235,33,0,0,235,1,112,160,227,0,0,0,239,0,64,45,233,1,0,81,227,1,0,160,209,14,240,160,209,28,64,45,233,1,48,160,227,0,64,160,227,2,32,65,226,4,48,131,224,4,64,67,224,1,32,82,226,251,255,255,90,3,0,160,225,28,128,189,232,0,128,189,232,0,64,45,233,10,32,65,226,33,17,65,224,33,18,129,224,33,20,129,224,33,24,129,224,161,17,160,225,1,49,129,224,131,32,82,224,1,16,129,82,10,32,130,66,48,32,130,226,0,32,192,229,1,0,64,226,0,0,81,227,239,255,255,27,0,128,189,232,0,64,45,233,0,16,160,225,36,0,143,226,9,0,128,226,233,255,255,235,24,0,143,226,12,16,160,227,1,32,160,225,0,16,160,225,1,0,160,227,4,112,160,227,0,0,0,239,0,128,189,232,32,32,32,32,32,32,32,32,32,32,32,0]
    write "fibo"
  end

  #helper to write the file
  def write name
    writer = Elf::ObjectWriter.new(@program , Elf::Constants::TARGET_ARM)
    assembly = writer.text
    # use this for getting the bytes to compare to :  
    # puts assembly
    writer.save("#{name}_test.o")
    assembly.text.bytes.each_with_index do |byte , index|
      is = @should[index]
      assert_equal  byte , is , "@#{index.to_s(16)} #{byte.to_s(16)} != #{is.to_s(16)}"
    end
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
