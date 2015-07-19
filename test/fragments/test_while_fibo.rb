require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def test_while_fibo
    @string_input = <<HERE
def fibonaccit(n) # n == r0
      a = 0           # a == r1
      b = 1           # b = r2
      while( n > 1 ) do                   #BUG comment lines + comments behind function calls
        tmp = a       # r3 <- r1
        a = b         # r1 <- r2
        b = tmp + b   #  r4 = r2 + r3  (r4 transient)  r2 <- r4
        n = n - 1      # r0 <- r2   for call,    #call ok
      end             #r5 <- r0 - 1    n=n-1 through r5 tmp
      b.putint()
      return b
end               # r0 <- r5

fibonaccit( 10 )
HERE
    @expect =  [Virtual::Return ]
    check
  end

  # a hand coded version of the fibonachi numbers (moved to kernel to be able to call it)
  #  not my hand off course, found in the net from a basic introduction
  def ttest_kernel_fibo
    int = Register::Integer.new(Virtual::RegisterMachine.instance.receiver_register)
    fibo  = @object_space.get_class_by_name(:Object).resolve_method(:fibo)
    main = @object_space.main
    main.mov int , 10
    main.call( fibo )
    main.mov( Virtual::RegisterMachine.instance.receiver_register , Virtual::RegisterMachine.instance.return_register )
    putint = @object_space.get_class_by_name(:Object).resolve_method(:putint)
    main.call( putint )
    @should = [0x0,0x40,0x2d,0xe9,0x1,0x0,0x52,0xe3,0x2,0x0,0xa0,0xd1,0x7,0x0,0x0,0xda,0x1,0x30,0xa0,0xe3,0x0,0x40,0xa0,0xe3,0x4,0x30,0x83,0xe0,0x4,0x40,0x43,0xe0,0x1,0x20,0x42,0xe2,0x1,0x0,0x52,0xe3,0xfa,0xff,0xff,0x1a,0x3,0x0,0xa0,0xe1,0x0,0x80,0xbd,0xe8]
    @target = [:Object , :fibo]
    write "fibo"
  end

end
