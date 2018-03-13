require_relative "helper"

module Mom
  class TestSimpleCall < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "5.mod4")
      @first = @stats.next
    end

    def test_if_compiles
      assert_equal  @stats.last.class , SimpleCall , @stats
    end
    def test_method_name
      assert_equal  @stats.last.method.name , :mod4 , @stats.last.to_rxf
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall] , @stats
    end
  end
end
