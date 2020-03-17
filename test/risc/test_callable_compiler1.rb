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
        puts ins.to_s
      end
    end

    def test_1
      @compiler.translate_method( @platform , [])
    end
  end
end
