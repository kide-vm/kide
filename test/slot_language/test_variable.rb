require_relative "helper"

module SlotLanguage
  class TestVariable < MiniTest::Test
    include SlotHelper
    def compile_var(str)
      var = compile(str)
      assert  var.is_a?(Variable)
      assert_equal :a , var.name
      var
    end
    def test_local
      assert_equal Variable , compile_var("a").class
    end
    def test_inst
      assert_equal MessageVariable , compile_var("@a").class
    end
    def test_local_chain
      chain = compile_var("a.b")
      assert_equal Variable , chain.chain.class
      assert_equal :b , chain.chain.name
    end
    def test_local_chain2
      chain = compile_var("a.b.c")
      assert_equal Variable , chain.chain.chain.class
      assert_equal :c , chain.chain.chain.name
    end
    def test_inst_chain
      chain = compile_var("@a.b")
      assert_equal MessageVariable , chain.class
      assert_equal Variable , chain.chain.class
      assert_equal :b , chain.chain.name
    end
  end
end
