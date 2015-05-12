require_relative "../helper"

class TestList < MiniTest::Test

  def setup
    @list = ::Parfait::List.new_object
  end
  def test_list_create
    assert @list.empty?
  end
  def test_empty_list_doesnt_return
    assert_equal nil , @list.get(3)
  end
  def test_one_set0
    assert_equal 1 , @list.set(0,1)
  end
  def test_one_set1
    assert_equal :some , @list.set(1,:some)
  end
  def test_two_sets
    assert_equal 1 , @list.set(0,1)
    assert_equal :some , @list.set(1,:some)
  end
  def test_one_get1
    test_one_set0
    assert_equal 1 , @list.get(0)
  end
  def test_one_get2
    test_one_set1
    assert_equal :some , @list.get(1)
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
end
