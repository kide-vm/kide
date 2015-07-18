require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if_basic
    @string_input = <<HERE
if( n < 12)
  3
else
  4
end
HERE
  @expect =  [Virtual::Return ]
  check
  end

  def ttest_if_function
    @string_input = <<HERE
def itest(n)
      if( n < 12)
        "then".putstring()
      else
        "else".putstring()
      end
end

itest(20)
HERE
  @expect =  [Virtual::Return ]
  check
  end
end
