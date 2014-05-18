require_relative 'helper'

class TestArmAsm < MiniTest::Test
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
  def test_push
    code = @machine.push [:lr] 
    assert_code code , :push ,  [0x00,0x40,0x2d,0xe9] #e9 2d 40 00
  end
  def test_pop
    code = @machine.pop [:pc] 
    assert_code code , :pop , [0x00,0x80,0xbd,0xe8] #e8 bd 80 00
  end
  def test_swi
    code = @machine.swi	 0x05 
    assert_code code , :swi , [0x05,0x00,0x00,0xef]#ef 00 00 05
  end
end
