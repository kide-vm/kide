require_relative "../helper"

module Risc
  class TestPlaform < MiniTest::Test

    def test_arm_factory_exists
      assert Platform.for("Arm")
    end
    def test_inter_factory_exists
      assert Platform.for("Interpreter")
    end
    def test_factory_raise
      assert_raises{ Platform.for("NotArm")}
    end
    def test_allocate
      allocator = Platform.new.allocator(FakeCompiler.new)
      assert_equal FakeCompiler , allocator.compiler.class
    end
  end
end
