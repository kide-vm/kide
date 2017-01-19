require_relative 'helper'

module Rubyx
  class TestRubyHello < MiniTest::Test
    include RubyxTests
    Branch = Risc::Branch
    Label = Risc::Label

    def setup
      @string_input = as_main '"Hello there".putstring'
      Risc.machine.boot
      #      do_clean_compile
      RubyCompiler.compile @string_input
      Risc::Collector.collect_space
      @interpreter = Risc::Interpreter.new
      @interpreter.start Risc.machine.init
    end

    def test_chain
      #show_ticks
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, RegToSlot,
             LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, RiscTransfer, FunctionCall, Label,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RiscTransfer, Syscall, RiscTransfer, RiscTransfer, RegToSlot,
             Label, FunctionReturn, RiscTransfer, SlotToReg, SlotToReg,
             Label, FunctionReturn, RiscTransfer, Syscall, NilClass]
    end

    def test_overflow
      instruction = ticks( 24 )
      assert_equal Risc::FunctionCall , instruction.class
      assert_equal :putstring , instruction.method.name
    end

    def test_ruby_hello
      done = ticks(45)
      assert_equal NilClass , done.class
      assert_equal "Hello there" , @interpreter.stdout
    end

  end
end
