require_relative "helper"

module Risc
  class TestPositionMath < MiniTest::Test

    def setup
      @pos = Position.new(self , 5)
    end
    def test_add
      res = @pos + 5
      assert_equal 10 , res
    end
    def test_sub
      res = @pos - 3
      assert_equal 2 , res
    end
    def test_sub_pos
      res = @pos - Position.new(@pos,4)
      assert_equal 1 , res
    end
    def test_lg
      assert @pos > Position.new(@pos,4)
    end
    def test_tos
      assert_equal "0x5" , @pos.to_s
    end
    def test_reset_ok
      pos = @pos.set(10)
      assert_equal 10 , pos
    end
    def test_object_class_test
      assert_equal :object , @pos.object_class
    end
    def test_object_class_instr
      assert_equal :instruction , Position.new(Label.new("hi","ho",FakeAddress.new(1)),4).object_class
    end
    def test_at
      pos = Position.at(5)
      assert_equal 5 , pos.at
    end
  end
end
