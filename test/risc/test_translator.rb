require_relative "helper"

module Risc
  class TestTranslator < MiniTest::Test

    def setup
      Parfait.boot!
      @translator = Arm::Translator.new
    end

    def test_has_translate
      assert @translator.respond_to?(:translate)
    end
    def test_no_translate_junk
      assert_raises {@translator.translate( "Hi there")}
    end
    def test_translate_label
      label = Risc::Label.new("HI","ho" , FakeAddress.new(0))
      assert_equal "ho" ,label.to_cpu(@translator).name , label
    end

  end
end
