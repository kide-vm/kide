require_relative "../helper"

class TestList < MiniTest::Test

  def setup
    @list = ::Parfait::List.new
  end
  def test_isa
    assert @list.is_a? Parfait::List
    assert @list.is_a? Parfait::Indexed
  end
  def test_old_type
    assert_equal Parfait::Type , Register.machine.space.classes.keys.get_type.class
  end
  def test_old_type_push
    list = Register.machine.space.classes.keys
    assert_equal Parfait::Type , list.get_type.class
  end
  def test_new_type
    assert_equal Parfait::Type , @list.get_type.class
  end
  def test_new_type_push
    @list.push(1)
    assert_equal Parfait::Type , @list.get_type.class
  end
  def notest_type_is_first
    type = @list.get_type
    assert_equal 1 , type.variable_index(:type)
  end
  def notest_type_is_first_old
    type =  Register.machine.space.classes.keys.get_type
    assert_equal 1 , type.variable_index(:type)
  end

  def test_length0
    assert_equal 0 , @list.get_length
    assert_nil  @list.indexed_length
  end
  def test_offset
    assert_equal 2 , @list.get_offset
  end
  def test_indexed_index
    # 1 type , 2 indexed_length
    assert_equal 2 , @list.get_type.variable_index(:indexed_length)
  end
  def test_length1
    @list.push :one
    assert_equal 1 , @list.get_length
    assert_equal 1 , @list.indexed_length
    assert_equal 1 , @list.get_internal_word(Parfait::TYPE_INDEX + 1)
  end
  def test_list_inspect
    @list.set(1,1)
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
    assert_equal 2 , @list.set(1,2)
    assert_equal 1 , @list.get_internal_word(2)
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
    assert_equal 2 , @list.get(1)
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
    assert_nil  @list.index_of( :four )
  end
  def test_inspect
    test_many_get
    assert @list.inspect.include?("one") , @list.inspect
    assert @list.inspect.include?("three") , @list.inspect
  end
  def test_inlcude
    test_many_get
    assert_equal true , @list.include?( :two )
    assert_equal false , @list.include?( :four )
  end
  def test_empty_empty
    assert_equal true , @list.empty?
  end
  def test_empty_notempty
    assert_equal 1 , @list.set(1,1)
    assert_equal false , @list.empty?
  end
  def test_first
    test_many_get
    assert_equal :one , @list.first
  end
  def test_first_empty
    assert_nil  @list.first
  end
  def test_last
    test_many_get
    assert_equal :three , @list.last
  end
  def test_last_empty
    assert_nil  @list.last
  end
end
