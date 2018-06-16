require_relative "helper"

module Risc
  class TestTranslator < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
      @translator = Arm::Translator.new
    end

    def test_translate_label
      label = Parfait.object_space.get_main.risc_instructions
      assert_equal "Space_Type.main" ,label.to_cpu(@translator).name , label
    end

    def test_translate_space
      assert @machine.translate(:arm)
    end

    def test_no_loops_in_chain
      @machine.translate(:arm)
      @machine.position_all
      init = Parfait.object_space.get_init
      all = []
      init.cpu_instructions.each do |ins|
        assert !all.include?(ins)
        all << ins
      end
    end
    def test_no_risc #by assembling, risc doesnt have assemble method
      @machine.translate(:arm)
      @machine.position_all
      @machine.object_positions.keys.each do |method|
        next unless method.is_a? Parfait::TypedMethod
        method.cpu_instructions.each do |ins|
          ins.assemble(DevNull.new)
        end
      end
    end

  end
end
