require_relative 'helper'

module Arm
  class TestControl < MiniTest::Test
    include ArmHelper

    def test_b
      # the address is what an assembler calculates (a signed number for the amount of instructions),
      # ie the relative (to pc) address -8 (pipeline) /4 so save space
      # so the cpu adds the value*4 and starts loading that (load, decode, execute)
      code = @machine.b(	0 ) #this jumps to the next next instruction
      assert_code code , :b , [0x0,0x0,0x0,0xea] #ea 00 00 00
    end
    def test_call #see comment above. bx not implemented (as it means into thumb, and no thumb here)
      code = @machine.call(	-4 ,{} )#this jumps to the next instruction
      assert_code code , :call, [0xff,0xff,0xff,0xeb] #ea ff ff fe
    end
    def test_method_call
      Risc.machine.boot
      bin = Parfait::BinaryCode.new(1)
      Risc::Position.set(bin , 0x20,Parfait.object_space.get_main)
      Risc::Position.set(@binary , 0)
      code = @machine.call(	bin ,{} )#this jumps to the next instruction
      Risc::Position.set(code , 0, @binary)
      assert_code code , :call, [0x08,0x0,0x0,0xeb]
    end
    def test_swi
      code = @machine.swi( 0x05 )
      assert_code code , :swi , [0x05,0x00,0x00,0xef]#ef 00 00 05
    end
    def test_swi_neg
      assert_raises(RuntimeError) do
        assert_code @machine.swi("0x05") , :swi , [0x05,0x00,0x00,0xef]
      end
    end
  end
end
