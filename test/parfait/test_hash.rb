require_relative "../helper"

class TestLists < MiniTest::Test

  def setup
    @list = ::Parfait::Hash.new
  end
  def test_list_create
    assert @list.empty?
  end
  def test_empty_list_doesnt_return
    assert_equal nil , @list.get(3)
    assert_equal nil , @list.get(:any)
  end
  def test_one_set1
    assert_equal 1 , @list.set(1,1)
  end
  def test_one_set2
    assert_equal :some , @list.set(1,:some)
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
    assert_equal :some , @list.get(1)
  end
  def test_many_get
    shouldda  = { :one => 1 , :two => 2 , :three => 3}
    shouldda.each do |k,v|
      @list.set(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v , @list.get(k)
    end
  end
end
