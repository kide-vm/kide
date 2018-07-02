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
      assert_equal Fixnum , @inter.loaded_at.class
    end
    def test_translator
      assert IdentityTranslator.new
    end
  end
  class TestIdentityTranslator < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @translator = IdentityTranslator.new
    end

    def test_load_translates_label
      label = Risc.label("test" , "test",nil)
      load = Risc.load_constant("source" , label , :r1)
      translated = @translator.translate(load)
      assert label != translated.constant
    end
  end

end
