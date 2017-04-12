require_relative "helper"

module Vool
  class TestLocalMom < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
      @method = compile_first_method( "a = 5")
    end

    def compile_first_method input
      lst = VoolCompiler.compile as_main( input )
      assert_equal Parfait::Class , lst.clazz.class , input
      method = lst.clazz.get_method(:main)
      assert method
      lst.to_mom( nil ).first
    end

    def test_class_compiles
      assert_equal Mom::SlotConstant , @method.first.class , @method
    end
    def test_slot_is_set
      assert @method.first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @method.first.left[0]
    end
    def test_slot_gets_self
      assert_equal :self , @method.first.left[1]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @method.first.left[-1]
    end
    def test_slot_assigns_something
      assert @method.first.right
    end
    def test_slot_assigns_int
      assert_equal IntegerStatement ,  @method.first.right.class
    end
  end
end
