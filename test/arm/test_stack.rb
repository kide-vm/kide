require_relative 'arm-helper'

class TestStack < MiniTest::Test
  include ArmHelper

  def test_push
    code = @machine.push [:lr] 
    assert_code code , :push ,  [0x00,0x40,0x2d,0xe9] #e9 2d 40 00
  end
  def test_push_three
    code = @machine.push [:r0,:r1,:lr] 
    assert_code code , :push ,  [0x03,0x40,0x2d,0xe9] #e9 2d 40 03
  end
  def test_push_no_link
    code = @machine.push [:r0,:r1,:r2 ,:r3,:r4,:r5] 
    assert_code code , :push ,  [0x3f,0x00,0x2d,0xe9] #e9 2d 00 3f
  end
  def test_pop
    code = @machine.pop [:pc] 
    assert_code code , :pop , [0x00,0x80,0xbd,0xe8] #e8 bd 80 00
  end
  def test_pop_three
    code = @machine.pop [:r0,:r1,:pc] 
    assert_code code , :pop , [0x03,0x80,0xbd,0xe8] #e8 bd 80 03
  end
  def test_pop_no_pc
    code = @machine.pop [:r0,:r1,:r2 ,:r3,:r4,:r5] 
    assert_code code , :pop , [0x3f,0x00,0xbd,0xe8] #e8 bd 00 3f
  end
  
end
