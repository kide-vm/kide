require_relative "../helper"

module Risc
  class TestBuilderInfer < MiniTest::Test

    def setup
      Parfait.boot!
      Risc.boot!
      @init = Parfait.object_space.get_init
      @compiler = Risc::MethodCompiler.new( @init )
      @builder  = @compiler.compiler_builder(@init)
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
    def test_caller_obj
      assert_equal :Message , @builder.infer_type(:caller_obj).class_name
    end
    def test_message
      assert_equal :Message , @builder.infer_type(:message).class_name
    end
    def test_next_message
      assert_equal :Message , @builder.infer_type(:next_message).class_name
    end

  end
end
