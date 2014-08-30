require_relative 'arm-helper'

class TestMoves < MiniTest::Test
  include ArmHelper

  def test_mov
    code = @machine.mov  :r0,  5
    assert_code code , :mov , [0x05,0x00,0xa0,0xe3] #e3 a0 10 05
  end
  def test_mvn
    code = @machine.mvn  :r1,  5
    assert_code code , :mvn , [0x05,0x10,0xe0,0xe3] #e3 e0 10 05
  end
end
