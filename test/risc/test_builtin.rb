require_relative "helper"

module Risc
  class TestBuiltinFunction < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def test_has_boot_function
      assert Builtin.boot_functions
    end
    def test_boot_function_type
      assert_equal Array, Builtin.boot_functions.class
    end
    def test_boot_function_length
      assert_equal 23, Builtin.boot_functions.length
    end
    def test_boot_function_first
      assert_equal MethodCompiler, Builtin.boot_functions.first.class
    end
  end
end
