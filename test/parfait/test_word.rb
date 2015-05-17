require_relative "../helper"

class TestEmptyWord < MiniTest::Test

  def setup
    @word = ::Parfait::Word.new_object(0)
  end
  def def_same
    assert_equal @word , ::Parfait::Word.new_object(0)
  end
  def test_word_create
    assert @word.empty?
  end
  def test_empty_is_zero
    assert_equal 0 , @word.length
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @word.get_char(1)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @word.set_char(1 , 32)
    end
  end
end
class TestWord < MiniTest::Test

  def setup
    @word = ::Parfait::Word.new_object(5)
  end
  def test_len
    assert_equal 5 , @word.length
  end
  def def_same
    assert_equal @word , ::Parfait::Word.new_object(5)
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @word.get_char(-6)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @word.set_char(6 , 32)
    end
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @word.get_char(6)
    end
  end
  def test_index_check_set
    assert_raises RuntimeError do
      @word.set_char(-6 , 32)
    end
  end
  def pest_one_char
    assert 32 , @word.set_char(1 , 32)
  end
  def pest_empty_word_doesnt_return
    assert_equal nil , @word.get(3)
  end
  def pest_one_set0
    assert_equal 1 , @word.set(0,1)
  end
  def pest_one_set1
    assert_equal :some , @word.set(1,:some)
  end
  def pest_two_sets
    assert_equal 1 , @word.set(0,1)
    assert_equal :some , @word.set(1,:some)
  end
  def pest_one_get1
    pest_one_set0
    assert_equal 1 , @word.get(0)
  end
  def pest_one_get2
    pest_one_set1
    assert_equal :some , @word.get(1)
  end
  def pest_many_get
    shouldda  = { 1 => :one , 2 => :two , 3 => :three}
    shouldda.each do |k,v|
      @word.set(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v , @word.get(k)
    end
  end
end
