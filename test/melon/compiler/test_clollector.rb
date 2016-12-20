require_relative "helper"

module Melon
  class TestCollector < MiniTest::Test

    def setup
      Register.machine.boot unless Register.machine.booted
    end

    def test_ivar_name
      Compiler.compile  "class TestIvar < Object ; def meth; @ivar;end; end"
      itest = Parfait::Space.object_space.get_class_by_name(:TestIvar)
      assert itest.instance_type.instance_names.include?(:ivar) , itest.instance_type.instance_names.inspect
    end

    def test_ivar_assign
      Compiler.compile  "class TestIvar2 < Object ; def meth; @ivar = 5 ;end; end"
      itest = Parfait::Space.object_space.get_class_by_name(:TestIvar2)
      assert itest.instance_type.instance_names.include?(:ivar) , itest.instance_type.instance_names.inspect
    end

    def test_ivar_operator_assign
      Compiler.compile  "class TestIvar3 < Object ; def meth; @ivar += 5 ;end; end"
      itest = Parfait::Space.object_space.get_class_by_name(:TestIvar3)
      assert itest.instance_type.instance_names.include?(:ivar) , itest.instance_type.instance_names.inspect
    end

  end
end
