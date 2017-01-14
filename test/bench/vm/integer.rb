require_relative 'helper'

class BenchInt < MiniTest::Test
  include BenchTests

  def test_adds
    @main = "int count = 100352 - 352
             while_plus( count - 1)
               40.fibw( )
               count = count - 1
             end
             return count"
    check_remote 0
  end

  def test_calls
    @main = "int count = 1000
             while_plus( count - 1)
               20.fibr( )
               count = count - 1
             end
             return count"
    check_remote 0
  end

  def test_itos
    @main = "int count = 100352 - 352
             while_plus( count - 1)
               count.to_s( )
               count = count - 1
             end
             return count"
    check_remote 0
  end
  def test_loop
    @main = "int count = 100352 - 352
             while_plus( count - 1)
               count = count - 1
             end
             return count"
    check_remote 0
  end
end
