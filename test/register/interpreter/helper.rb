require_relative "../helper"
require "register/interpreter"

module Register
  module Ticker
    include AST::Sexp
    include InterpreterHelpers

    def setup
      Register.machine.boot
      do_clean_compile
      Vm.compile_ast( @input )
      Collector.collect_space
      @interpreter = Interpreter.new
      @interpreter.start Register.machine.init
    end

    # must be after boot, but before main compile, to define method
    def do_clean_compile
    end

  end
end
