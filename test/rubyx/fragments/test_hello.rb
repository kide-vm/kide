require_relative 'helper'

module Rubyx
  class TestRubyHello < MiniTest::Test
    include RubyxTests
    Branch = Register::Branch
    Label = Register::Label

    def setup
      @string_input = as_main '"Hello there".putstring'
      Register.machine.boot
      #      do_clean_compile
      RubyCompiler.compile @string_input
      Register::Collector.collect_space
      @interpreter = Register::Interpreter.new
      @interpreter.start Register.machine.init
    end

    def test_chain
      #show_ticks
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, RegToSlot,
             LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegisterTransfer, Syscall, RegisterTransfer, RegisterTransfer, RegToSlot,
             Label, FunctionReturn, RegisterTransfer, SlotToReg, SlotToReg,
             Label, FunctionReturn, RegisterTransfer, Syscall, NilClass]
    end

    def test_overflow
      instruction = ticks( 24 )
      assert_equal Register::FunctionCall , instruction.class
      assert_equal :putstring , instruction.method.name
    end

    def test_ruby_hello
      done = ticks(45)
      assert_equal NilClass , done.class
      assert_equal "Hello there" , @interpreter.stdout
    end

  end
end
