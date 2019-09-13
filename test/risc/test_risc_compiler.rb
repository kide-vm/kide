require_relative "helper"

module Risc
  class TestMomCompilerTranslate < MiniTest::Test
    include MomCompile

    def setup
      @comp = compile_mom( "class Space ; def main(); main{return 'Ho'};return 'Hi'; end; end;")
      @linker = @comp.to_risc.translate(:interpreter)
    end

    def test_translate_class
      assert_equal Linker , @linker.class
    end
    def test_linker_has_constants
      assert_equal Array , @linker.constants.class
    end
    def test_linker_constants_not_empty
      assert !@linker.constants.empty?
    end
    def test_linker_constants_contains_hi
      assert @linker.constants.include?("Hi")
    end
    def test_linker_constants_contains_ho
      assert @linker.constants.include?("Ho")
    end
    def test_translate_platform
      assert_kind_of Platform , @linker.platform
    end
    def test_translate_assemblers
      assert_equal Assembler , @linker.assemblers.first.class
    end
    def test_assembler_code
      assert_equal Label , @linker.assemblers.first.instructions.class
    end
    def test_assembler_assembled
      assert_equal LoadConstant , @linker.assemblers.first.instructions.next.class
    end
    def test_no_loops_in_chain
      @linker.assemblers.each do |asm|
        all = []
        asm.instructions.each do |ins|
          assert !all.include?(ins) , "Double in #{asm.callable.name}:#{ins}"
          all << ins
        end
      end
    end
    def test_no_risc
      @linker.position_all
      @linker.create_binary
      @linker.assemblers.each do |asm|
        asm.instructions.each do |ins|
          ins.assemble(Util::DevNull.new)
        end # risc instruction don't have an assemble
      end
    end
  end
end
