require_relative "../helper"

class TestEmptyWord < MiniTest::Test

  def setup
    Register.machine.boot unless Register.machine.booted
    @word = ::Parfait::Word.new(0)
  end
  def test_word_create
    assert @word.empty?
  end
  def test_empty_is_zero
    assert_equal 0 , @word.length
  end
  def test_index_check_get
    assert_raises RuntimeError do
      @word.get_char(0)
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
    @word = ::Parfait::Word.new(5)
  end
  def test_len
    assert_equal 5 , @word.length
  end
  def test_first_char
    assert_equal 32 , @word.get_char(1)
  end
  def test_equals_copy
    assert_equal @word.copy , @word
  end
  def test_equals_copy2
    @word.set_char(1 , 2)
    @word.set_char(5 , 6)
    assert_equal @word.copy , @word
  end
  def test_equals_same
    assert_equal ::Parfait::Word.new(5) , @word
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
  def test_one_char
    assert_equal 32 , @word.set_char(1 , 32)
  end
  def test_one_char_doesnt_cause_problems
    @word.set_char(1 , 32)
    assert_equal 32 , @word.get_char(1)
  end
  def test_one_set1
    assert_equal 44 , @word.set_char(1, 44 )
  end
  def test_two_sets
    assert_equal 1 , @word.set_char(1,1)
    assert_equal 44 , @word.set_char(1,44)
  end
  def test_one_get1
    test_one_set1
    assert_equal 44 , @word.get_char(1)
  end
  def test_many_get
    shouldda  = { 1 => 11 , 2 => 22 , 3 => 33}
    shouldda.each do |k,v|
      @word.set_char(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v , @word.get_char(k)
    end
  end
end
