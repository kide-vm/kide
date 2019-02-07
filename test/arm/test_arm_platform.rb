require_relative "helper"

module Arm
  class TestArmPlatform < MiniTest::Test
    def setup
      @arm = Risc::Platform.for("Arm")
    end
    def test_platform_class
      assert_equal Arm::ArmPlatform , @arm.class
    end
    def test_platform_translator_class
      assert_equal Arm::Translator , @arm.translator.class
    end
    def test_platform_loaded_class
      assert_equal ::Integer , @arm.loaded_at.class
    end
  end
end
