require_relative 'helper'

class TestStack < MiniTest::Test
  include ArmHelper

  def test_push
    code = @machine.push [:lr] 
    assert_code code , :push ,  [0x00,0x40,0x2d,0xe9] #e9 2d 40 00
  end
  def test_pop
    code = @machine.pop [:pc] 
    assert_code code , :pop , [0x00,0x80,0xbd,0xe8] #e8 bd 80 00
  end
end
