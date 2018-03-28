require_relative "../helper"

class DevNull
  def write_unsigned_int_32( _ );end
end
module Risc
  class TestTranslator < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
      @translator = Arm::Translator.new
    end

    def test_translate_label
      label = Parfait.object_space.get_main.risc_instructions
      assert @translator.translate(label) , label
    end

    def test_translate_space
      assert @machine.translate_arm
    end

    def test_no_loops_in_chain
      @machine.position_all
      init = Parfait.object_space.get_init
      all = []
      init.cpu_instructions.each do |ins|
        assert !all.include?(ins)
        all << ins
      end
    end
    def test_no_risc #by assembling, risc doesnt have assemble method
      @machine.position_all
      @machine.objects.each do |id , method|
        next unless method.is_a? Parfait::TypedMethod
        method.cpu_instructions.each do |ins|
          begin
            ins.assemble(DevNull.new)
          rescue LinkException
            ins.assemble(DevNull.new)
          end
        end
      end
    end

  end
end
