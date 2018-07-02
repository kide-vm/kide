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
  end
end
