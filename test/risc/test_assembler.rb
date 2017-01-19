require_relative "../helper"

module Risc
  class TestAssembler < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
    end
    def test_no_object
      @assembler = Assembler.new(@machine , {})
      assert_nil @machine.translate_arm
    end
    def test_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert_nil @machine.translate_arm
    end

    def test_write_fails
      @assembler = Assembler.new(@machine , {})
      assert_raises{ @assembler.assemble} #must translate first
    end
    def test_assemble_no_objects
      @assembler = Assembler.new(@machine , {})
      assert_nil @machine.translate_arm
      assert @assembler.assemble
    end

    def test_translate_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert_nil @machine.translate_arm
    end
    def test_assemble_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert_nil @machine.translate_arm
      assert @assembler.assemble
    end
    def test_write_space
      @assembler = Assembler.new(@machine , Collector.collect_space)
      assert_nil @machine.translate_arm
      assert @assembler.write_as_string
    end
  end
end
