require_relative "helper"

module Mom
  class TestAssignemnt < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "@a = 5")
    end

    def test_if_compiles
      assert_equal SlotConstant , @stats.class , @stats
    end
    def test_length
      assert_equal 1 , @stats.length
    end
    def test_assigns_class
      assert_equal Vool::IntegerStatement , @stats.right.class , @stats.inspect
    end
    def test_assigns_value
      assert_equal 5 , @stats.right.value , @stats.inspect
    end

  end
end
