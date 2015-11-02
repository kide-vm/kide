require_relative "../helper"

class TestObject < MiniTest::Test

  def setup
     @object = ::Parfait::Object.new
  end

  def test_object_create
    # another test sometime adds a field variable. Maybe should reboot ?
    res = 1
    [:boo1 , :boo2 , :runner].each { |v| res += 1 if @object.get_layout.variable_index(v) }
    assert_equal res ,  @object.get_layout.instance_length , @object.get_layout.inspect
  end

  def test_empty_object_doesnt_return
    assert_equal nil ,  @object.internal_object_get(3)
  end

  def test_one_set1
    assert_equal 1 ,  @object.internal_object_set(1,1)
  end

  def test_one_set2
    assert_equal :some ,  @object.internal_object_set(2,:some)
  end

  def test_two_sets
    assert_equal 1 ,  @object.internal_object_set(1,1)
    assert_equal :some ,  @object.internal_object_set(1,:some)
  end
  def test_one_get1
    test_one_set1
    assert_equal 1 ,  @object.internal_object_get(1)
  end
  def test_one_get2
    test_one_set2
    assert_equal :some ,  @object.internal_object_get(2)
  end
  def test_many_get
    shouldda  = { 1 => :one , 2 => :two , 3 => :three}
    shouldda.each do |k,v|
       @object.internal_object_set(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v ,  @object.internal_object_get(k)
    end
  end
end
