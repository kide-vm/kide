require_relative 'helper'

class TestFunctions < MiniTest::Test
  include Fragments

  def test_functions
    @string_input = <<HERE
def minus(a,b)
      a - b
    end
    def plus(a, b) 
      a + b
    end
    def times(a, b)
      if( b == 0 )
        a = 0
      else
        m = minus(b, 1)
        t = times(a, m)
        a = plus(a,t)
      end
end
    
tim = times(7,6)
tim.putint()
HERE
    @should = [0x0,0x40,0x2d,0xe9,0x2,0x30,0x41,0xe0,0x3,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0x2,0x30,0x41,0xe0,0x3,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8]
    @output = "        42  "
    @target = [:Object , :minus]
    parse
    write "functions"
  end
end
