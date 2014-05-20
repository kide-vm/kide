require_relative 'helper'

class TestFibo < MiniTest::Test
  
  def setup
    @program = Vm::Program.new "Arm"
  end

  # a hand coded version of the fibonachi numbers
  #  not my hand off course, found in the net from a basic introduction
  def test_fibo
    int = Vm::Integer.new(1) # the one is funny, but the fibo is _really_ tight code and reuses registers
    fibo  = @program.get_or_create_function(:fibo)
    @program.main.mov( int , 10 )
    @program.main.call( fibo )
#    putint = @program.get_or_create_function(:putint)
#    @program.main.call( putint )
    write 20 , "fibo"
  end
  
  #helper to write the file
  def write len ,name
    writer = Elf::ObjectWriter.new(@program , Elf::Constants::TARGET_ARM)
    writer.save("#{name}_test.o")    
  end
  
end