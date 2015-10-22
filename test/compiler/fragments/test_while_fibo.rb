require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def test_while_fibo
    @string_input = <<HERE
class Object
  int fibonaccit(int n)
        int a = 0
        int b = 1
        while( n > 1 )
          int tmp = a
          a = b
          b = tmp + b
          n = n - 1
        end
        b.putint()
        return b
  end

  int main()
    fibonaccit( 10 )
  end
end
HERE
  @expect =  [ [SaveReturn,Register::GetSlot,Register::Set,Register::Set,
                Register::Set,Register::Set,RegisterTransfer,FunctionCall] ,[RegisterTransfer,GetSlot,FunctionReturn] ]
    check
  end

  # a hand coded version of the fibonachi numbers (moved to kernel to be able to call it)
  #  not my hand off course, found in the net from a basic introduction
  def ttest_kernel_fibo
    int = Register::Integer.new(Register::RegisterMachine.instance.receiver_register)
    fibo  = @object_space.get_class_by_name(:Object).resolve_method(:fibo)
    main = @object_space.main
    main.mov int , 10
    main.call( fibo )
    main.mov( Register::RegisterMachine.instance.receiver_register , Register::RegisterMachine.instance.return_register )
    putint = @object_space.get_class_by_name(:Object).resolve_method(:putint)
    main.call( putint )
    @should = [0x0,0x40,0x2d,0xe9,0x1,0x0,0x52,0xe3,0x2,0x0,0xa0,0xd1,0x7,0x0,0x0,0xda,0x1,0x30,0xa0,0xe3,0x0,0x40,0xa0,0xe3,0x4,0x30,0x83,0xe0,0x4,0x40,0x43,0xe0,0x1,0x20,0x42,0xe2,0x1,0x0,0x52,0xe3,0xfa,0xff,0xff,0x1a,0x3,0x0,0xa0,0xe1,0x0,0x80,0xbd,0xe8]
    @target = [:Object , :fibo]
    write "fibo"
  end

end
