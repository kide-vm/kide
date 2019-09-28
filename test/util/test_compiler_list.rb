require_relative "../helper"

module Util
  class MethodCompiler
    include Util::CompilerList
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  class TestComplierListOne < Minitest::Test

    def setup
      @compiler = MethodCompiler.new(:one)
    end
    def add_two
      @compiler.add_method_compiler MethodCompiler.new(:two)
    end
    def test_basic_length
      assert_equal 1 , @compiler.num_compilers
    end
    def test_last_empty
      assert_equal :one , @compiler.last_compiler.name
    end
    def test_find_one
      assert_equal :one , @compiler.find_compiler{|c| c.name == :one}.name      
    end
  end
  class TestComplierListTwo < Minitest::Test

    def setup
      @compiler = MethodCompiler.new(:one)
      @compiler.add_method_compiler MethodCompiler.new(:two)
    end
    def test_can_add
      assert_equal 2 , @compiler.num_compilers
    end
    def test_last_two
      assert_equal :two , @compiler.last_compiler.name
    end
    def test_find_two
      assert_equal :two , @compiler.find_compiler{|c| c.name == :two}.name
    end
  end


















end
