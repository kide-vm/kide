require_relative "helper"

module Risc
  class TestMethodCompiler < MiniTest::Test
    include ScopeHelper

    def setup
    end

    def in_test_vool(str)
      vool = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(in_Test(str))
      vool.to_mom(nil)
      vool
    end
    def in_test_mom(str)
      FIXMERubyX::RubyXCompiler.new(in_Test(str)).ruby_to_mom()
    end
    def create_method(body = "@ivar = 5")
      in_test_vool("def meth; #{body};end")
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
      clazz = in_test_vool("def meth; @ivar = 5 ;end")
      assert_equal Vool::Statements , clazz.body.class
      assert_equal Vool::MethodStatement , clazz.body.first.class
    end

    def test_callable_method_instance_type
      in_test_vool("def meth; @ivar = 5; @ibar = 4;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.instance_type.get_method(:meth)
      assert_equal 1, method.self_type.variable_index(:ivar)
      assert_equal 2, method.self_type.variable_index(:ibar)
    end
    def test_callable_method_has_one_local
      in_test_vool("def meth; local = 5 ; a = 6;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.get_method(:meth)
      assert_equal 3 , method.frame_type.instance_length
      assert_equal 1 , method.frame_type.variable_index(:local)
      assert_equal 2 , method.frame_type.variable_index(:a)
    end
    def constant_setup(input)
      mom = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(in_Test(input))
      assert_equal Mom::MomCompiler , mom.class
      compiler = mom.method_compilers.first
      assert_equal MethodCompiler , compiler.class
      compiler
    end
    def test_has_method_constant
      compiler = constant_setup("def meth; return 'Hi';end")
      assert compiler.constants.include?("Hi")
    end
    def test_has_block_constant
      compiler = constant_setup("def meth; meth{return 'Ho'};return 'Hi';end")
      assert compiler.constants.include?("Ho")
    end
    def test_return_label
      compiler = constant_setup("def meth; return 'Hi';end")
      assert_equal "return_label",  compiler.return_label.name
    end
  end
end
