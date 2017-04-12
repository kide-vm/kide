require_relative "helper"

module Mom
  class TestAssignemnt < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def compile_first input
      lst = Vool::VoolCompiler.compile in_Space( input )
      lst.to_mom( nil )
    end

  end
end
