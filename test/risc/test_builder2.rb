require_relative "../helper"

module Risc
  class TestBuilderInfer < MiniTest::Test

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      method = FakeCallable.new
      @compiler = Risc::MethodCompiler.new( method, SlotMachine::Label.new( "source_name", "return_label") )
      @builder  = @compiler.builder(method)
    end
    def test_list
      assert_equal :List , @builder.infer_type(:list).class_name
    end
    def test_name
      assert_equal :Word , @builder.infer_type(:name).class_name
    end
    def test_word
      assert_equal :Word , @builder.infer_type(:word).class_name
    end
    def test_caller
      assert_equal :Message , @builder.infer_type(:caller).class_name
    end
    def test_caller_reg
      assert_equal :Message , @builder.infer_type(:caller_reg).class_name
    end
    def test_define_twice
      @builder.caller_reg!
      assert_raises{ @builder.caller_reg! }
    end
    def test_define_conditionally_first
      assert_equal :r1 , @builder.caller_reg?.symbol
    end
    def test_define_conditionally_again
      first = @builder.caller_reg!
      assert_equal first , @builder.caller_reg?
    end
    def test_caller_tmp
      assert_equal :Message , @builder.infer_type(:caller_tmp).class_name
    end
    def test_caller_obj
      assert_equal :Message , @builder.infer_type(:caller_obj).class_name
    end
    def test_caller_const
      assert_equal :Message , @builder.infer_type(:caller_const).class_name
    end
    def test_caller_self
      assert_equal :Message , @builder.infer_type(:caller_self).class_name
    end
    def test_caller_1
      assert_equal :Message , @builder.infer_type(:caller_1).class_name
    end
    def test_message
      assert_equal :Message , @builder.infer_type(:message).class_name
    end
    def test_next_message
      assert_equal :Message , @builder.infer_type(:next_message).class_name
    end

  end
end
