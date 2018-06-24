require_relative 'helper'

module Mains
  class TestAdds < MainsTest

    def test_ruby_adds
      run_main_file "adds"
      assert_equal 10 , get_return
    end
    def test_ruby_subs
      run_main_file "subs"
      assert_equal 0 , get_return
    end
    def test_ruby_adds_fibo
      run_main_file "fibo"
      assert_equal 8 , get_return
    end
  end
end
