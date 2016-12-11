require_relative 'helper'

class BenchWord < MiniTest::Test
  include BenchTests

  def test_hello
    @main = <<HERE
    int count = 100352 - 352
    Word hello = "Hello there"
    while_plus( count - 1)
      hello.putstring()
      count = count - 1
     end
     return 1
HERE
    check_remote 1
  end
end
