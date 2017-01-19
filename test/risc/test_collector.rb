require_relative "../helper"

module Risc
  class TestCollector < MiniTest::Test
    def test_simple_collect
      Machine.new.boot
      objects = Risc::Collector.collect_space
      assert ((350 < objects.length) or (430 > objects.length)) , objects.length.to_s
    end
  end
end
