require_relative "../helper"

module Risc
  class TestCallableCompiler1 < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main("return 5").to_risc
      @platform = Platform.for(:arm)
    end
    def test_init
      @compiler.risc_instructions.each do |ins|
        ins.register_names.each do |name|
          assert ! RegisterValue.look_like_reg(name)
        end
      end
    end

    def test_1
      @compiler.translate_method( @platform , [])
      @compiler.risc_instructions.each do |ins|
        ins.register_names.each do |name|
          assert RegisterValue.look_like_reg(name)
        end
      end
    end
  end
end
