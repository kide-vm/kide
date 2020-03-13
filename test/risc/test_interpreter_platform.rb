require_relative "helper"

module Risc
  class TestInterpreterPlatform < MiniTest::Test
    def setup
      @inter = Platform.for("Interpreter")
    end
    def test_platform_class
      assert_equal Risc::InterpreterPlatform , @inter.class
    end
    def test_platform_translator_class
      assert_equal Risc::IdentityTranslator , @inter.translator.class
    end
    def test_platform_loaded_class
      assert_equal ::Integer , @inter.loaded_at.class
    end
    def test_translator
      assert IdentityTranslator.new
    end
    def test_registers
      assert_equal 16  , @inter.num_registers
    end
  end
  class TestIdentityTranslator < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      @translator = IdentityTranslator.new
    end

    def test_load_translates_label
      label = Risc.label("test" , "test",nil)
      load = Risc.load_constant("source" , label )
      translated = @translator.translate(load)
      assert label != translated.constant
    end
  end

end
