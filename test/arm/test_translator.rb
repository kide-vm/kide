require_relative 'helper'

module Arm
  class TestStack < MiniTest::Test

    def test_init
      assert Translator.new
    end

    def test_dynamic
      trans = Translator.new
      jump = Risc::DynamicJump.new("" , :r1)
      res = trans.translate jump
      assert :r1 , res.from
    end
  end
end
