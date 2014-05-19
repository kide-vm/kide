require_relative 'helper'

class TestControl < MiniTest::Test
  include ArmHelper

  def test_b
    # the address is what an assembler calculates (a signed number for the amount of instructions), 
    # ie the relative (to pc) address -8 (pipeline) /4 so save space
    # so the cpu adds the value*4 and starts loading that (load, decode, execute)
    code = @machine.b	 -4  #this jumps to the next instruction
    assert_code code , :b , [0xff,0xff,0xff,0xea] #ea ff ff fe
  end
  def test_call #see comment above. bx not implemented (as it means into thumb, and no thumb here)
    code = @machine.call	 -4 ,{} #this jumps to the next instruction
    assert_code code , :call, [0xff,0xff,0xff,0xeb] #ea ff ff fe
  end
  def test_swi
    code = @machine.swi	 0x05 
    assert_code code , :swi , [0x05,0x00,0x00,0xef]#ef 00 00 05
  end
end
