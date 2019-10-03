
require_relative "helper"

module Vool
  class TestBlockArg < MiniTest::Test
    include SlotMachineCompile

    def setup
      @ret = compile_slot( as_main("self.main {|elem| elem = 5 } "))
    end
    def test_is_compiler
      assert_equal SlotMachine::SlotCollection , @ret.class
    end
    def test_has_method
      assert_equal Parfait::CallableMethod , @ret.method_compilers.get_method.class
    end
    def test_method_has_block
      assert @ret.method_compilers.get_method.blocks , "No block created"
    end
  end
  class TestBlockLocal < MiniTest::Test
    include SlotMachineCompile
    def setup
      @ret = compile_slot( as_main("self.main {|elem| local = 5 } "))
      @block = @ret.method_compilers.get_method.blocks
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
  class TestBlockMethodArg < MiniTest::Test
    include SlotMachineCompile

    def setup
    end
    def test_method_arg_compiles
      ret = compile_slot( as_main("self.main {|elem| arg = 5 } "))
      assert ret
    end
    def test_method_local_compiles
      ret = compile_slot( as_main("local = 5 ; self.main {|elem| local = 10 } "))
      assert ret
    end
  end
end
