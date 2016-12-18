require_relative "helper"

module Melon
  class TestClass < MiniTest::Test

    def test_creates_class
      Register.machine.boot
      before = Parfait::Space.object_space.classes.length
      @string_input = <<HERE
class Testing
end
HERE
      Compiler.compile @string_input
      assert_equal 1 ,  Parfait::Space.object_space.classes.length - before , "No classes created"
    end
  end
end
