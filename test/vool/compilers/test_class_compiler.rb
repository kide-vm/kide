require_relative "helper"

module Vool
  class TestClassCompiler < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def compile_in_test input
      VoolCompiler.compile in_Test(input)
      itest = Parfait.object_space.get_class_by_name(:Test)
      assert itest
      itest
    end

    def test_compile_class_one
      itest = compile_in_test "def meth; @ivar; end"
      assert itest.instance_type.names.include?(:ivar) , itest.instance_type.names.inspect
    end

    def test_compile_class_two
      itest = compile_in_test "def meth; @ivar; end;def meth2(arg); @trivar = 5; end"
      assert itest.instance_type.names.include?(:trivar) , itest.instance_type.names.inspect
    end

  end
end
