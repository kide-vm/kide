require_relative "helper"

module Risc
  class TestPositionListener < MiniTest::Test

    def setup
      @object = Dummy.new
      @dependent = Dummy.new
      @pos = Position.new(@object).set(0)
      Position.new(@dependent).set(0)
      @listener = PositionListener.new(@dependent)
    end
    def test_register
      assert @pos.position_listener(@listener)
    end
    def test_no_fire
      @pos.position_listener(self)
      @pos.set(0)
      assert_equal 0 , Position.get(@object).at
    end
    def test_at
      @pos.position_listener( @listener)
      @pos.set(8)
      assert_equal 8 , Position.at(8).at
    end
  end
end
