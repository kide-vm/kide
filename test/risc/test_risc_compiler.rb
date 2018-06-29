require_relative "helper"

module Risc
  class TestRiscCompiler < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def create_method
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      vool.to_mom(nil)
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth)
    end

    def test_method_has_source
      method = create_method
      assert_equal Vool::IvarAssignment ,  method.source.class
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
      clazz = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; @ivar = 5 ;end")
      assert_equal Vool::MethodStatement , clazz.body.class
    end

    def test_method_statement_has_class
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      clazz = vool.to_mom(nil)
      assert vool.body.clazz
    end

    def test_parfait_class_creation
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; @ivar = 5;end")
      clazz = vool.to_mom(nil)
      assert_equal Parfait::Class , vool.body.clazz.class
    end

    def test_typed_method_instance_type
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; @ivar = 5; @ibar = 4;end")
      vool.to_mom(nil)
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.instance_type.get_method(:meth)
      assert_equal 1, method.for_type.variable_index(:ivar)
      assert_equal 2, method.for_type.variable_index(:ibar)
    end

    def test_vool_method_has_one_local
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; local = 5 ; a = 6;end")
      vool.to_mom(nil)
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.get_method(:meth)
      assert_equal 3 , method.frame_type.instance_length
      assert_equal 1 , method.frame_type.variable_index(:local)
      assert_equal 2 , method.frame_type.variable_index(:a)
    end

    def test_typed_method_has_one_local
      vool = RubyX::RubyXCompiler.ruby_to_vool in_Test("def meth; local = 5 ; a = 6;end")
      vool.to_mom(nil)
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.instance_type.get_method(:meth)
      assert_equal 3 , method.frame_type.instance_length
      assert_equal 1 , method.frame_type.variable_index(:local)
    end

  end
end
