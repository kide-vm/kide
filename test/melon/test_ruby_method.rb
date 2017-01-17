require_relative "helper"

module Melon
  class TestRubyMethod < MiniTest::Test
    include CompilerHelper

    def setup
      Register.machine.boot
    end

    def create_method
      RubyCompiler.compile in_Test("def meth; @ivar ;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_method(:meth)
    end

    def test_creates_method_in_class
      method = create_method
      assert method , "No method created"
    end

    def test_method_has_source
      method = create_method
      assert_equal "(ivar :@ivar)",  method.source.to_s
    end

    def test_method_has_no_args
      method = create_method
      assert_equal 1 , method.args_type.instance_length
    end

    def test_method_has_no_locals
      method = create_method
      assert_equal 1 , method.locals_type.instance_length
    end

  end
end
