require_relative "../helper"

class TestObject < MiniTest::Test

  def setup
     @object = ::Parfait::Object.new
  end

  def test_object_create
    # another test sometime adds a field variable. Maybe should reboot ?
    res = 1
    [:boo1 , :boo2 , :bro , :runner].each { |v| res += 1 if @object.get_layout.variable_index(v) }
    assert_equal res ,  @object.get_layout.instance_length , @object.get_layout.inspect
  end

  def test_empty_object_doesnt_return
    assert_equal nil ,  @object.get_internal_word(3)
  end

  def test_one_set1
    assert_equal 1 ,  @object.set_internal_word(1,1)
  end

  def test_one_set2
    assert_equal :some ,  @object.set_internal_word(2,:some)
  end

  def test_two_sets
    assert_equal 1 ,  @object.set_internal_word(1,1)
    assert_equal :some ,  @object.set_internal_word(1,:some)
  end
  def test_one_get1
    test_one_set1
    assert_equal 1 ,  @object.get_internal_word(1)
  end
  def test_one_get2
    test_one_set2
    assert_equal :some ,  @object.get_internal_word(2)
  end
  def test_many_get
    shouldda  = { 1 => :one , 2 => :two , 3 => :three}
    shouldda.each do |k,v|
       @object.set_internal_word(k,v)
    end
    shouldda.each do |k,v|
      assert_equal v ,  @object.get_internal_word(k)
    end
  end
end
