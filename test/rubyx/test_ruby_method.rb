require_relative "helper"

module Rubyx
  class TestRubyMethod < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def create_method
      Vool::VoolCompiler.compile in_Test("def meth; @ivar ;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth)
    end

    def create_method_arg
      Vool::VoolCompiler.compile in_Test("def meth_arg(arg); arg ;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth_arg)
    end

    def create_method_local
      Vool::VoolCompiler.compile in_Test("def meth_local(arg); local = 5 ;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth_local)
    end

    def test_creates_method_in_class
      method = create_method
      assert method , "No method created"
    end

    def test_method_has_source
      method = create_method
      assert_equal Vool::ScopeStatement,  method.source.class
      assert_equal Vool::InstanceVariable,  method.source.first.class
    end

    def test_method_has_no_args
      method = create_method
      assert_equal 1 , method.args_type.instance_length
    end

    def test_method_has_no_locals
      method = create_method
      assert_equal 1 , method.locals_type.instance_length
    end

    def test_method_has_args
      method = create_method_arg
      assert_equal 2 , method.args_type.instance_length
    end

    def test_method_has_locals
      method = create_method_local
      assert_equal 2 , method.locals_type.instance_length
    end

    def test_method_create_tmp
      name = create_method.create_tmp
      assert_equal :tmp_1 , name
    end

    def test_method_add_tmp
      method = create_method_local
      method.create_tmp
      assert_equal 3 , method.locals_type.instance_length
    end

  end
end
