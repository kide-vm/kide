require_relative 'arm-helper'

class TestMoves < MiniTest::Test
  include ArmHelper

  def test_mov
    code = @machine.mov  :r1,  5
    assert_code code , :mov , [0x05,0x10,0xa0,0xe3] #e3 a0 10 05
  end
  def test_mov_pc
    code = @machine.mov  :pc,  5
    assert_code code , :mov , [0x05,0xf0,0xa0,0xe3] #e3 a0 f0 06
  end
  def test_mov_256
    code = @machine.mov  :r1,  256
    assert_code code , :mov , [0x01,0x1c,0xa0,0xe3] #e3 a0 1c 01
  end
  def test_mov_max_128
    code = @machine.mov  :r1,  128
    assert_code code , :mov , [0x80,0x10,0xa0,0xe3] #e3 a0 10 80
  end
  def test_mov_big
    code = @machine.mov  :r0,  0x222  # is not 8 bit and can't be rotated by the arm system in one instruction
    code.set_position(0)
    begin  # mov 512(0x200) = e3 a0 0c 02    add 34(0x22) = e2 80 00 22
      assert_code code , :mov , [ 0x02,0x0c,0xa0,0xe3 , 0x22,0x00,0x80,0xe2] 
    rescue Register::LinkException
      retry
    end
  end
  def test_mvn
    code = @machine.mvn  :r1,  5
    assert_code code , :mvn , [0x05,0x10,0xe0,0xe3] #e3 e0 10 05
  end
  def test_constant_small # like test_mov
    const = Virtual::ObjectConstant.new
    const.set_position( 13 ) # 13 = 5 + 8 , 8 for the arm pipeline offset, gets subtracted
    code = @machine.mov :r1 , 5
    code.set_position(0)
    #TODO check this in decompile
    assert_code code , :mov , [0x05,0x10,0xa0,0xe3] #e3 ef 10 05
  end
  def test_constant_big # like test_mov_big
    const = Virtual::ObjectConstant.new
    const.set_position( 0x222 )
    code = @machine.mov :r0 , 0x222 
    code.set_position(0)
    begin  # mov 512(0x200) = e3 a0 0c 02    add 34(0x22) = e2 80 00 22
      assert_code code , :mov , [ 0x02,0x0c,0xa0,0xe3 , 0x22,0x00,0x80,0xe2] 
    rescue Register::LinkException
      retry
    end
  end
end
