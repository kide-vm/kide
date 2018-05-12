require_relative "../helper"

module Risc
  class TestPlaform < MiniTest::Test

    def test_factory_exists
      assert Platform.for("Arm")
    end
    def test_factory_raise
      assert_raises{ Platform.for("NotArm")}
    end
    def test_platform_class
      arm = Platform.for("Arm")
      assert_equal Arm::ArmPlatform , arm.class
    end
    def test_platform_translator_class
      arm = Platform.for("Arm")
      assert_equal Arm::Translator , arm.translator.class
    end
    def test_platform_loaded_class
      arm = Platform.for("Arm")
      assert_equal Fixnum , arm.loaded_at.class
    end
  end
end
