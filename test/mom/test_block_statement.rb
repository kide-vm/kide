
require_relative "helper"

module Vool
  class TestBlockStatement < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!
      @ret = compile_mom( as_test_main("self.main {|elem| elem } "))
    end
    def test_is_compiler
      assert_equal Mom::MomCompiler , @ret.class
    end
    def test_has_method
      assert_equal Parfait::CallableMethod , @ret.method_compilers.first.method.class
    end
    def test_method_has_block
      assert @ret.method_compilers.first.method.blocks , "No block created"
    end
  end
  class TestBlockCreated < MiniTest::Test
    include MomCompile
    def setup
      Parfait.boot!
      @ret = compile_mom( as_test_main("self.main {|elem| local = 5 } "))
      @block = @ret.method_compilers.first.method.blocks
    end
    def test_block_arg_type
      assert_equal Parfait::Type, @block.arguments_type.class
    end
    def test_block_arg_type_name
      assert_equal 1, @block.arguments_type.variable_index(:elem)
    end
    def test_block_local_type
      assert_equal Parfait::Type, @block.frame_type.class
    end
    def test_block_frame_type_name
      assert_equal 1, @block.frame_type.variable_index(:local)
    end
  end
end
