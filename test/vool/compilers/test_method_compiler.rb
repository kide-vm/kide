require_relative "helper"

module Vool
  class TestMethodCompiler < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def create_method
      VoolCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth)
    end

    def test_method_has_source
      method = create_method
      assert_equal IvarAssignment ,  method.source.class
    end

    def test_method_has_no_locals
      method = create_method
      assert_equal 1 , method.frame_type.instance_length
    end

    def test_method_has_no_args
      method = create_method
      assert_equal 1 , method.args_type.instance_length
    end

    def test_creates_method_in_class
      method = create_method
      assert method , "No method created"
      assert_equal Parfait::VoolMethod , method.class
    end

    def test_creates_method_statement_in_class
      clazz = VoolCompiler.ruby_to_vool in_Test("def meth; @ivar = 5 ;end")
      assert_equal MethodStatement , clazz.body.class
    end

    def test_method_statement_has_class
      clazz = VoolCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      assert clazz.body.clazz
    end

    def test_parfait_class_creation
      clazz = VoolCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      assert_equal Parfait::Class , clazz.body.clazz.class
    end

    def test_method_statement_has_class_in_main
      clazz = VoolCompiler.ruby_to_vool in_Space("def meth; @ivar = 5;end")
      assert clazz.body.clazz
    end

    def test_method_has_one_local
      VoolCompiler.ruby_to_vool in_Test("def meth; local = 5 ;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.get_method(:meth)
      assert_equal 2 , method.frame_type.instance_length
    end

  end
end
