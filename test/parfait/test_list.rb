require_relative "helper"

module Parfait
  class TestList < ParfaitTest

    def setup
      super
      @list = ::Parfait::List.new
    end
    def test_isa
      assert @list.is_a? Parfait::List
    end
    def test_old_type
      assert_equal Parfait::Type , Parfait.object_space.classes.keys.get_type.class
    end
    def test_old_type_push
      list = Parfait.object_space.classes.keys
      assert_equal Parfait::Type , list.get_type.class
    end
    def test_new_type
      assert_equal Parfait::Type , @list.get_type.class
    end
    def test_new_type_push
      @list.push(1)
      assert_equal Parfait::Type , @list.get_type.class
    end
    def test_length0
      assert_equal 0 , @list.get_length
      assert_equal 0,  @list.indexed_length
    end
    def test_offset
      assert_equal 2 , @list.get_offset
    end
    def test_indexed_index
      # 0 type , 1 indexed_length
      assert_equal 1 , @list.get_type.variable_index(:indexed_length)
    end
    def test_length1
      @list.push :one
      assert_equal 1 , @list.get_length
      assert_equal 1 , @list.indexed_length
      assert_equal :one , @list.get_internal_word(Parfait::TYPE_INDEX + 2)
    end
    def test_list_inspect
      @list.set(0,1)
      assert_equal "1" , @list.inspect
    end
    def test_list_equal
      @list.set(1,1)
      list = ::Parfait::List.new
      list.set(1,1)
      assert @list.equal? list
    end
    def test_list_create
      assert @list.empty?
    end
    def test_list_len
      assert_equal 0 , @list.get_length
    end
    def test_empty_list_doesnt_return
      assert_nil  @list.get(3)
    end
    def test_one_set1
      assert_equal 2 , @list.set(0,2)
      assert_equal 1 , @list.get_internal_word(1)
      assert_equal 2 , @list.get_internal_word(2)
    end
    def test_set1_len
      @list.set(0,1)
      assert_equal 1 , @list.get_length
    end
    def test_one_get1
      test_one_set1
      assert_equal 2 , @list.get(0)
    end
    def test_one_set2
      assert_equal :some , @list.set(2,:some)
    end
    def test_set2_len
      @list.set(1,:some)
      assert_equal 2 , @list.get_length
    end
    def test_two_sets
      assert_equal 1 , @list.set(1,1)
      assert_equal :some , @list.set(1,:some)
    end
    def test_one_get2
      test_one_set2
      assert_equal :some , @list.get(2)
    end
    def test_find
      @list.set(1,1)
      @list.set(2,2)
      assert_equal 2, @list.find{|i| i == 2}
    end
    def test_not_find
      @list.set(1,1)
      assert_nil @list.find{|i| i == 3}
    end
    def test_empty_empty
      assert_equal true , @list.empty?
    end
    def test_empty_notempty
      assert_equal 1 , @list.set(1,1)
      assert_equal false , @list.empty?
    end
    def test_first_empty
      assert_nil  @list.first
    end
    def test_last_empty
      assert_nil  @list.last
    end
  end
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
    def test_to_a
      arr = @list.to_a
      assert_equal Array , arr.class
      assert_equal 3 , arr.length
    end
  end
end
