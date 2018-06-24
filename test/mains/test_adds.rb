require_relative 'helper'

module Mains
  class TestAdds < MainsTest

    def test_ruby_adds
      run_main_file "adds"
    end
    def test_ruby_subs
      run_main_file "subs"
    end
    def test_ruby_adds_fibo
      run_main_file "fibo"
    end
  end
end
