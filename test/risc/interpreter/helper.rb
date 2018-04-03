require_relative "../helper"
require "util/eventable"
require "risc/interpreter"

module Risc
  module Ticker
    include InterpreterHelpers
    include CompilerHelper

    def setup
      Risc.machine.boot
      do_clean_compile
      Vool::VoolCompiler.ruby_to_vool( @string_input )
      Collector.collect_space
      @interpreter = Interpreter.new
      @interpreter.start Risc.machine.risc_init
    end

    # must be after boot, but before main compile, to define method
    def do_clean_compile
    end

  end
end
