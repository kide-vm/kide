require_relative "helper"

module Risc
  class TestBranchListener < MiniTest::Test
    def setup
      @machine = Risc.machine.boot
      @machine.translate(:interpreter)
      @machine.position_all
    end

    def test_has_init
    end
  end
end
