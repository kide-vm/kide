require_relative "../helper"

module VoolBlocks
  class TestClassAssignMom < MiniTest::Test
    include MomCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def as_class_method(source)
      "class Space;def self.main();#{source};end;end"
    end
    def test_block_not_compiles
      source =  "main{|val| val = 0}"
      vool = Ruby::RubyCompiler.compile( as_class_method(source) ).to_vool
      begin
        vool.to_mom(nil)
      rescue => err
        assert err.message.include?("Blocks")
      end
    end
  end
end
