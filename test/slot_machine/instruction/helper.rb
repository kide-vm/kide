require_relative '../helper'

module SlotMachine
  class InstructionMock < Instruction
    def initialize
      super("mocking")
    end
  end

  # Most SlotMachineInstructionTests test the risc instructions of the mom instruction
  # quite carefully, ie every instruction, every register.
  #
  # This is done with the assert methods in risc_assert
  #
  # Most tests go through instructions from top to bottom.
  # For working code, one can get a list of those instructions by using the all_str as message
  # Most tests will test for length and give the all_str as message to see where it went wrong
  # like: assert_equal 8 , all.length , all_str
  class SlotMachineInstructionTest < MiniTest::Test
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
