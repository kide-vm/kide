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
    def test_data_length
      assert_equal 12 , @list.data_length
    end
    def test_class_data_length
      assert_equal 12 , List.data_length
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
      assert_equal 3 , @list.class.type_length
    end
    def test_indexed_index
      # 0 type , 1 indexed_length
      assert_equal 1 , @list.get_type.variable_index(:indexed_length)
    end
    def test_length1
      @list.push :one
      assert_equal 1 , @list.get_length
      assert_equal 1 , @list.indexed_length
      assert_equal :one , @list.get_internal_word(List.type_length )
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
      assert_equal 2 , @list.get_internal_word(List.type_length)
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
end
