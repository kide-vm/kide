require_relative "../helper"

module Risc
  class TestCodeBuilder < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      label = SlotMachine::Label.new( "source_name", "return_label")
      @builder = Risc::MethodCompiler.new( FakeCallable.new ,label).builder("source")
      @label = Risc.label("source","name")
      @start = @builder.compiler.current
    end
    def built
      @start.next
    end
    def test_has_build
      assert @builder.respond_to?(:build)
    end
    def test_has_attribute
      assert_nil @builder.built
    end
    def test_message
      reg = @builder.message
      assert_equal :message , reg.symbol
      assert_equal :Message , reg.type.class_name
    end
    def test_if_zero
      ret = @builder.if_zero @label
      assert_equal IsZero , ret.class
      assert_equal @label , ret.label
    end
    def test_if_not_zero
      ret = @builder.if_not_zero @label
      assert_equal IsNotZero , ret.class
      assert_equal @label , ret.label
    end
    def test_branch
      ret = @builder.branch @label
      assert_equal Branch , ret.class
      assert_equal @label , ret.label
    end
  end
end
