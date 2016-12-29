require_relative "../helper"

class TestDictionary < MiniTest::Test

  def setup
    @lookup = ::Parfait::Dictionary.new
  end
  def test_dict_create
    assert_equal 0 , @lookup.length
    assert @lookup.empty?
  end
  def test_empty_dict_doesnt_return
    assert_nil  @lookup.get(3)
    assert_nil  @lookup.get(:any)
  end
  def test_one_set1
    assert_equal 1 , @lookup.set(1,1)
    assert_equal 1 , @lookup.length
  end
  def test_one_double
    assert_equal 1 , @lookup.set(1,1)
    assert_equal 3 , @lookup.set(1,3)
    assert_equal 1 , @lookup.length
  end
  def test_one_double2
    assert_equal 1 , @lookup.set(:one,1)
    assert_equal 3 , @lookup.set(:one,3)
    assert_equal 1 , @lookup.length
  end
  def test_one_set2
    assert_equal :some , @lookup.set(1,:some)
  end
  def test_two_sets
    assert_equal 1 , @lookup.set(1,1)
    assert_equal :some , @lookup.set(1,:some)
  end
  def test_one_get1
    test_one_set1
    assert_equal 1 , @lookup.get(1)
  end
  def test_one_get2
    test_one_set2
    assert_equal :some , @lookup.get(1)
  end
  def test_inspect1
    @lookup[:key] = :value
    assert_equal "Dictionary{key => value ,}" , @lookup.inspect
  end
  def test_inspect2
    @lookup[:key1] = :value1
    @lookup[:key2] = :value2
    assert_equal "Dictionary{key1 => value1 ,key2 => value2 ,}" , @lookup.inspect
  end
  def test_many_get
    shouldda  = { :one => 1 , :two => 2 , :three => 3}
    shouldda.each do |k,v|
      @lookup.set(k,v)
    end
    @lookup.each do |k,v|
      assert_equal v , shouldda[k]
    end
  end

  def test_values
    assert @lookup.values
  end
  def test_keys
    assert @lookup.keys
  end
end
