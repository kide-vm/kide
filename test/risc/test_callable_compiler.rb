require_relative "helper"
module Risc
  class TestCallableCompiler < MiniTest::Test
    def setup
      Parfait.boot!({})
      @compiler = Risc.test_compiler
    end
    def test_ok
      assert @compiler
    end
    def test_current
      assert @compiler.current
    end
    def test_current_label
      assert_equal Label , @compiler.current.class
      assert_equal "start_label" , @compiler.current.name
    end
    def test_slot
      assert @compiler.risc_instructions
    end
    def test_const
      assert_equal Array , @compiler.constants.class
    end
    def test_load_class
      object = @compiler.load_object(Parfait.object_space)
      assert_equal RegisterValue , object.class
      assert object.is_object?
    end
    def test_load_code
      object = @compiler.load_object(Parfait.object_space)
      assert_equal LoadConstant , @compiler.current.class
      assert_equal Parfait::Space , @compiler.current.constant.class
    end
    def test_load_data
      object = @compiler.load_object(1)
      assert_equal LoadData , @compiler.current.class
      assert_equal Integer , @compiler.current.constant.class
    end
  end
end
