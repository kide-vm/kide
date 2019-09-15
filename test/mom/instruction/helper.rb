require_relative '../helper'

module Mom
  class InstructionMock < Instruction
    def initialize
      super("mocking")
    end
  end

  class MomInstructionTest < MiniTest::Test
    include Output
    def setup
      Parfait.boot!(Parfait.default_test_options)
      @instruction = instruction
      @compiler = Risc::MethodCompiler.new(Risc::FakeCallable.new , Label.new("source","start"))
      @instruction.to_risc(@compiler)
      @risc = @compiler.risc_instructions
    end

    def risc(at)
      return @risc if at == 0
      @risc.next( at )
    end

    def all
      ret = []
      @risc.each {|i| ret << i}
      ret
    end

    def all_str
      class_list(all.collect{|i|i.class})
    end
  end

end
