require_relative "helper"

module Melon
  class TestMethod < MiniTest::Test
    include CompilerHelper

    def setup
      Register.machine.boot
    end

    def test_creates_method_in_class
      Compiler.compile in_Space("def meth; @ivar;end")
      space = Parfait.object_space.get_class
      method = space.get_method(:meth)
      assert method , "No method created"
    end

  end
end
