require_relative "helper"

module Mains
  class ClassTester < MiniTest::Test
    include MainsHelper

    def test_simple_call
      @input = code("return Space.get")
      assert_result 5 , ""
    end

    def test_inst_get
      @input = code("return Space.get" , "@inst = 5;return @inst")
      assert_result 5 , ""
    end

    def test_inst_set
      setter = "def self.set(num); @inst = num;end ;"
      @input = code("Space.set(6);return Space.get" , "return @inst" , setter)
      assert_result 6 , ""
    end

    def code( main , get = "return 5" , extra = "")
      @input = <<MAIN
      class Space
        #{extra}
        def self.get
          #{get}
        end
        def main(arg)
          #{main}
        end
      end
MAIN
    end
  end
end
