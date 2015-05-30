require_relative "../helper"

class TestList < MiniTest::Test

  def setup
    @list = ::Parfait::List.new_object
  end
  def test_list_create
    assert @list.empty?
  end
  def test_list_len
    assert_equal 0 , @list.get_length
  end
  def test_empty_list_doesnt_return
    assert_equal nil , @list.get(3)
  end
  def test_one_set1
    assert_equal 1 , @list.set(1,1)
  end
  def test_set1_len
    @list.set(1,1)
    assert_equal 1 , @list.get_length
  end
  def test_one_set2
    assert_equal :some , @list.set(2,:some)
  end
  def test_set2_len
    @list.set(2,:some)
    assert_equal 2 , @list.get_length
  end
  def test_two_sets
    assert_equal 1 , @list.set(1,1)
    assert_equal :some , @list.set(1,:some)
  end
  def test_one_get1
    test_one_set1
    assert_equal 1 , @list.get(1)
  end
  def test_one_get2
    test_one_set2
    assert_equal :some , @list.get(2)
  end
  def test_many_get
    shouldda  = { 1 => :one , 2 => :two , 3 => :three}
    shouldda.each do |k,v|
      @list.set(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v , @list.get(k)
    end
  end
  def test_delete_at
    test_many_get
    assert @list.delete_at 2
    assert_equal 2 , @list.get_length
    assert_equal 2 , @list.index_of( :three )
  end

  def test_delete
    test_many_get
    assert @list.delete :two
    assert_equal 2 , @list.get_length
    assert_equal 2 , @list.index_of( :three )
  end
  def test_index_of
    test_many_get
    assert_equal 2 , @list.index_of( :two )
    assert_equal 3 , @list.index_of( :three )
    assert_equal nil , @list.index_of( :four )
  end
  def test_incude
    test_many_get
    assert_equal true , @list.include?( :two )
    assert_equal false , @list.include?( :four )
  end
end
