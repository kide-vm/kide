require_relative "../helper"

module Risc
  class TestAssembler < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def pest_no_object
      @assembler = Assembler.new(@machine , {})
    end
    def pest_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
    end
    def pest_write_fails
      @assembler = Assembler.new(@machine , {})
      assert_raises{ @assembler.write_as_string} #must translate first
    end
    def pest_assemble_no_objects
      @assembler = Assembler.new(@machine , {})
      assert @machine.translate_arm
      assert @assembler.assemble
    end

    def pest_assemble_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert @machine.translate_arm
      assert @assembler.assemble
    end
    def test_write_space
      assert @machine.translate_arm
      assert @machine.position_all
      @assembler = Assembler.new(@machine , Collector.collect_space)
      #assert @assembler.write_as_string
    end
  end
end
