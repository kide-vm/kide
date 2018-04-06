require_relative "../helper"

class FakeBuilder
  attr_reader :built
  def add_instruction(ins)
    @built = ins
  end
end
module Risc
  class TestRegisterValue < MiniTest::Test

    def setup
      Risc.machine.boot
      @r0 = RiscValue.new(:r0 , :Message)
      @r1 = RiscValue.new(:r1 , :Space)
    end

    def test_r0
      assert_equal :r0 , @r0.symbol
    end

    def test_load_space
      move = @r0 << Parfait.object_space
      assert_equal LoadConstant , move.class
    end
    def test_transfer
      transfer = @r0 << @r1
      assert_equal Transfer , transfer.class
    end
    def test_calls_builder
      builder = FakeBuilder.new
      @r0.builder = builder
      @r0 << @r1
      assert_equal Transfer , builder.built.class
    end
  end
end
