require_relative "helper"

module Parfait
  class TestListMany < ParfaitTest
    def setup
      super
      @list = ::Parfait::List.new
      @shouldda = { 0 => :one , 1 => :two , 2 => :three}
      @shouldda.each{|k,v| @list.set(k,v)}
    end
    def test_next_value_ok
      assert_equal :two , @list.next_value(:one)
    end
    def test_next_value_end
      assert_nil @list.next_value(:three)
    end
    def test_delete_at
      assert @list.delete_at 1
      assert_equal 2 , @list.get_length
      assert_equal 1 , @list.index_of( :three )
    end
    def test_last
      assert_equal :three , @list.last
    end
    def test_many_get
      assert @list.delete :two
      assert_equal 2 , @list.get_length
      assert_equal 1 , @list.index_of( :three )
    end
    def test_index_of
      assert_equal 1 , @list.index_of( :two )
      assert_equal 2 , @list.index_of( :three )
      assert_nil  @list.index_of( :four )
    end
    def test_inspect
      assert @list.inspect.include?("one") , @list.inspect
      assert @list.inspect.include?("three") , @list.inspect
    end
    def test_inlcude
      assert_equal true , @list.include?( :two )
      assert_equal false , @list.include?( :four )
    end
    def test_next_value_not_int
      assert_nil @list.next_value(:three)
    end
    def test_each
      shouldda_values = @shouldda.values
      @list.each do |val|
        shouldda_values.delete val
      end
      assert_equal 0 , shouldda_values.length
    end
    def test_each_index
      @list.each_with_index do |val , index|
        assert_equal @list[index] , val
      end
    end
    def test_each_pair_length
      shouldda_values = @shouldda.values
      @list.each_pair do |key,val|
        shouldda_values.delete key
        shouldda_values.delete val
      end
      assert_equal 0 , shouldda_values.length
    end
    def test_each_pair_count
      counter = 0
      @list.each_pair do |key,val|
        counter += 1
      end
      assert_equal 2 , counter
    end
    def test_to_s
      assert_equal "[one ,two ,three , ]" , @list.to_s
    end
    def test_to_a
      arr = @list.to_a
      assert_equal Array , arr.class
      assert_equal 3 , arr.length
    end
  end
end
