require_relative "helper"

module Risc
  class TestMachinePos < MiniTest::Test
    def setup
      Parfait.boot!
      Risc.boot!
      @linker = RubyX::RubyXCompiler.new("class Space; def main(arg);a = 1;return a;end;end").ruby_to_risc(:arm)
      @linker.position_all
    end
    def test_positions_set
      @linker.object_positions.each do |obj , position|
        assert Position.get(obj).valid? , "#{Position.get(obj)} , #{obj.object_id.to_s(16)}"
      end
    end
    def test_one_main
      mains = @linker.assemblers.find_all{|asm| asm.method.name == :main }
      assert_equal 1 , mains.length
    end
    def test_assembler_num
      assert_equal 23 , @linker.assemblers.length
    end
  end
end
