require_relative "../helper"

module Risc
  class TestPosition < MiniTest::Test

    def test_creation_ok
      assert Position.new(0)
    end
    def test_creation_fail
      assert_raises {Position.new("0")}
    end
    def test_add
      res = Position.new(0) + 5
      assert_equal 5 , res
    end
    def test_sub
      res = Position.new(5) - 1
      assert_equal 4 , res
    end
    def test_sub_pos
      res = Position.new(5) - Position.new(1)
      assert_equal 4 , res
    end
    def test_set
      pos = Position.set(self , 5)
      assert_equal 5 , pos.at
    end
    def test_set_instr
      pos = Position.set( Risc::Label.new("hi","ho") , 0)
      assert_equal IPosition , pos.class
    end
    def tet_tos
      assert_equal "0x10" , Position.set(self).to_s
    end
    def test_reset_ok
      pos = Position.set(self , 5)
      pos = Position.set(self , 10)
      assert_equal 10 , pos.at
    end
    def test_reset_fail
      Position.set(self , 5)
      assert_raises{Position.set(self , 10000)}
    end
    def test_raises_set_nil
      assert_raises { Position.set(self,nil)}
    end
  end
end
