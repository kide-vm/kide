require_relative "helper"

module RubyX

  class TestIntegerCompile < MiniTest::Test
    include ParfaitHelper
    def source
      load_parfait(:integer)
    end
    def test_load
      assert source.include?("class Integer")
      assert source.length > 2000
    end
    def qtest_vool
      vool = compiler.ruby_to_vool source
      assert_equal Vool::ClassStatement , vool.class
      assert_equal :Object , vool.name
    end
    def qtest_mom
      mom = compiler.ruby_to_mom source
      assert_equal Mom::MomCollection , mom.class
    end
    def qtest_risc
      risc = compiler.ruby_to_risc source
      assert_equal Risc::RiscCollection , risc.class
    end
    def qtest_binary
      risc = compiler.ruby_to_binary source , :interpreter
      assert_equal Risc::Linker , risc.class
    end
  end
end
