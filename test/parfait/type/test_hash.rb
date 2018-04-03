require_relative "../../helper"

class TypeHash < MiniTest::Test

  def setup
    Risc.machine.boot
    @space = Parfait.object_space
    @types = @space.instance_variable_ged("@types")
    @first = @types.values.first
  end

  def test_hash
    assert_equal Parfait::Dictionary , @types.class
  end

  def test_length
    assert @types.length > 11
  end

  def test_two_hashs_not_equal
    assert @types.keys.last != @types.keys.first
  end

  def test_name
    assert_equal "Word_Type" , @types.values.first.name
  end

  def test_to_hash
    hash = @first.to_hash
    assert_equal hash[:type] , :Type
    assert_equal 2 ,  hash.length
  end
  def test_add_is_different
    type = @first.add_instance_variable :random , :Integer
    assert type != @first , "new: #{type.inspect} , old: #{@first.inspect}"
    assert @first.hash != type.hash
  end

  def test_hash_for_no_ivars
    list = @space.get_class_by_name(:NamedList )
    t1 = Parfait::Type.for_hash( list , type: :NewInt)
    t2 = Parfait::Type.for_hash( list , type: :NewObj)
    assert  t1.hash != t2.hash , "Hashes should differ"
  end
end
