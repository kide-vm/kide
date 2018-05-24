require_relative "helper"

module Risc
  class TestInterpreterPlatform < MiniTest::Test
    def setup
      @inter = Platform.for("Interpreter")
    end
    def test_platform_class
      assert_equal Risc::InterpreterPlatform , @inter.class
    end
    def test_platform_translator_class
      assert_equal Risc::IdentityTranslator , @inter.translator.class
    end
    def test_platform_loaded_class
      assert_equal Fixnum , @inter.loaded_at.class
    end
    def test_translator
      assert IdentityTranslator.new
    end
  end
  class TestIdentityTranslator < MiniTest::Test

    def setup
      @machine = Risc.machine.boot
      @translator = IdentityTranslator.new
    end

    def test_load_translates_label
      label = Label.new("test" , "test")
      load = Risc.load_constant("source" , label , :r1)
      translated = @translator.translate(load)
      assert label != translated.constant
    end
    def test_translate_first_label
      label = Parfait.object_space.get_main.risc_instructions
      assert_equal "Space_Type.main" ,label.to_cpu(@translator).name , label
    end

    def test_translate_space
      assert @machine.translate(:interpreter)
    end

    def test_no_loops_in_chain
      @machine.translate(:interpreter)
      @machine.position_all
      init = Parfait.object_space.get_init
      all = []
      init.cpu_instructions.each do |ins|
        assert !all.include?(ins)
        all << ins
      end
    end
    def test_no_risc
      @machine.translate(:interpreter)
      @machine.position_all
      @machine.create_binary
      @machine.objects.each do |id , method|
        next unless method.is_a? Parfait::TypedMethod
        method.cpu_instructions.each do |ins|
          ins.assemble(DevNull.new)
        end
      end
    end

  end

end
