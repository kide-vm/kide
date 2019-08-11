require_relative "helper"

module Risc
  class TestBuiltinFunction < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @functions = Builtin.boot_functions
    end
    def test_has_boot_function
      assert @functions
    end
    def test_boot_function_type
      assert_equal Array, @functions.class
    end
    def test_boot_function_length
      assert_equal 6, @functions.length
    end
    def test_boot_function_first
      assert_equal Mom::MethodCompiler, @functions.first.class
    end
  end
end
