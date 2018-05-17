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
  end
end
