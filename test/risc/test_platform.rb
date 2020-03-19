require_relative "../helper"

module Risc
  class TestPlaform < MiniTest::Test

    def test_arm_factory_exists
      assert Platform.for("Arm")
    end
    def test_inter_factory_exists
      assert Platform.for("Interpreter")
    end
    def test_factory_raise
      assert_raises{ Platform.for("NotArm")}
    end
    def test_allocate
      allocator = Platform.for("Interpreter").allocator(FakeCompiler.new)
      assert_equal FakeCompiler , allocator.compiler.class
    end
    def test_map_message
      assert_equal :r0 , Platform.new.assign_reg?(:message)
    end
    def test_map_sys
      assert_equal :r0 , Platform.new.assign_reg?(:syscall_1)
    end
    def test_map_id
      assert_nil Platform.new.assign_reg?(:id_some_id)
    end
    def test_names_len
      assert_equal 15 , Platform.new.register_names.length
    end
    def test_names_r
      assert_equal "r" , Platform.new.register_names.first.to_s[0]
      assert_equal "r" , Platform.new.register_names.last.to_s[0]
    end
  end
end
