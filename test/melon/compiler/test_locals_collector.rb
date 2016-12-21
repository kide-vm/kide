require_relative "helper"

module Melon
  class TestLocalsCollector < MiniTest::Test

    def setup
      Register.machine.boot unless Register.machine.booted
    end

    def parse_collect( input )
      ast = Parser::Ruby22.parse input
      LocalsCollector.new.collect(ast)
    end

    def test_no_locals
      locals = parse_collect "def meth; end"
      assert locals.empty?
    end

    def test_method_is_not_local
      locals = parse_collect("def meth2(arg1); foo ;end")
      assert locals.empty?
    end

    def test_local_assign_one
      locals = parse_collect("def meth2(arg1); foo = bar ;end")
      assert locals[:foo] , locals.inspect
    end
    def test_local_assign_two
      locals = parse_collect("def meth2(arg1); foo = bar ; groove = 1 + 2 ;end")
      assert locals.length == 2 , locals.inspect
    end

  end
end
