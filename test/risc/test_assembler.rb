require_relative "../helper"

module Risc
  class TestAssembler < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def test_no_object
      @assembler = Assembler.new(@machine , {})
    end
    def test_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
    end
    def test_write_fails
      @assembler = Assembler.new(@machine , {})
      assert_raises{ @assembler.write_as_string} #must translate first
    end
    def test_assemble_no_objects
      @assembler = Assembler.new(@machine , {})
      assert @machine.translate_arm
      assert @machine.position_all
    end

    def test_assemble_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert @machine.position_all
    end
    def test_write_space
      assert @machine.translate_arm
      assert @machine.position_all
      @assembler = Assembler.new(@machine , Collector.collect_space)
      #assert @assembler.write_as_string
    end
  end
end
