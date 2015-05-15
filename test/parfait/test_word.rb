require_relative "../helper"

class TestEmptyWord < MiniTest::Test

  def setup
    @list = ::Parfait::Word.new_object(0)
  end
  def test_list_create
    assert @list.empty?
  end
  def test_empty_is_zero
    assert_equal 0 , @list.length
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @list.get_char(1)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @list.set_char(1 , 32)
    end
  end
end
class TestWord < MiniTest::Test

  def setup
    @list = ::Parfait::Word.new_object(5)
  end
  def test_len
    assert_equal 5 , @list.length
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @list.get_char(-6)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @list.set_char(6 , 32)
    end
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @list.get_char(6)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @list.set_char(-6 , 32)
    end
  end
  def pest_one_char
    assert 32 , @list.set_char(1 , 32)
  end
  def pest_empty_list_doesnt_return
    assert_equal nil , @list.get(3)
  end
  def pest_one_set0
    assert_equal 1 , @list.set(0,1)
  end
  def pest_one_set1
    assert_equal :some , @list.set(1,:some)
  end
  def pest_two_sets
    assert_equal 1 , @list.set(0,1)
    assert_equal :some , @list.set(1,:some)
  end
  def pest_one_get1
    pest_one_set0
    assert_equal 1 , @list.get(0)
  end
  def pest_one_get2
    pest_one_set1
    assert_equal :some , @list.get(1)
  end
  def pest_many_get
    shouldda  = { 1 => :one , 2 => :two , 3 => :three}
    shouldda.each do |k,v|
      @list.set(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v , @list.get(k)
    end
  end
end
