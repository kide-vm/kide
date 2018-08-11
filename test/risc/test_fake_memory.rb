require_relative "../helper"

module Risc
  class TestFakeMemory < MiniTest::Test
    def setup
      @fake = FakeMemory.new(1 , 2,16)
    end
    def test_init
      assert @fake
    end
    def test_size
      assert_equal 16 , @fake.size
    end
    def test_not_instantiates
      assert_raises {FakeMemory.new(1,7)}
    end
    def test_access_fail_big
      assert_raises {@fake.set(20 , 12)}
    end
    def test_access_fail_minus
      assert_raises {@fake.set(-1 , 12)}
    end
    def test_set
      assert_equal 12 ,  @fake.set(2 , 12)
    end
    def test_set_arr
      assert_equal 12 ,  @fake[2] = 12
    end
    def test_get_no_init
      assert_nil @fake.get(2)
    end
    def test_get_arr
      assert_nil @fake[2]
    end
    def test_get_set
      @fake[2] = 12
      assert_equal 12 , @fake[2]
    end
    def test_set_all
      (2...16).each{ |i| @fake[i] = i * 2}
      assert_equal 4 , @fake[2]
      assert_equal 30 , @fake[15]
      assert_equal 16 , @fake.size
    end

  end
end
