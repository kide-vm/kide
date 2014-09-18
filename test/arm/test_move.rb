require_relative 'arm-helper'

class TestMoves < MiniTest::Test
  include ArmHelper

  def test_mov
    code = @machine.mov  :r0,  5
    assert_code code , :mov , [0x05,0x00,0xa0,0xe3] #e3 a0 10 05
  end
  def test_mov_pc
    code = @machine.mov  :pc,  6
    assert_code code , :mov , [0x06,0xf0,0xa0,0xe3] #e3 a0 f0 06
  end
  def test_mov_big
    code = @machine.mov  :r0,  0x222
    code.set_position(0)
    begin   #TODO use compiler to confirm codes here: this is just what passes
      assert_code code , :mov , [ 0x02,0x00,0xa0,0xe3 , 0xff,0x04,0x80,0xe2] 
    rescue Register::LinkException
      retry
    end
  end
  def test_mvn
    code = @machine.mvn  :r1,  5
    assert_code code , :mvn , [0x05,0x10,0xe0,0xe3] #e3 e0 10 05
  end
end
