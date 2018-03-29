require_relative "../helper"

module Risc
  class TestAssembler < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def est_init
      @assembler = Assembler.new(@machine)
    end
    def est_write_fails
      @assembler = Assembler.new(@machine)
      assert_raises{ @assembler.write_as_string} #must translate first
    end
    def test_write_space
      assert @machine.position_all
      @assembler = Assembler.new(@machine)
      assert @assembler.write_as_string
    end
  end
end
