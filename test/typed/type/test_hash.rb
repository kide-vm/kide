require_relative "../helper"

class TypeHash < MiniTest::Test

  def setup
    Register.machine.boot
    @space = Parfait.object_space
    @types = @space.instance_variable_get("@types")
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
    assert_equal "BinaryCode_Type" , @types.values.first.name
  end

  def test_to_hash
    assert_equal "BinaryCode_Type" ,  @first.name
    assert_equal :BinaryCode ,  @first.object_class.name
    hash = @first.to_hash
    assert_equal :Type , @first.types.first
    assert_equal hash[:type] , :Type
    assert_equal hash[:char_length] , :Integer
    assert_equal 2 , @first.instance_length
  end

  def test_hashcode_with_hash
    assert_equal @first.hash , Parfait::Type.hash_code_for_hash( @first.to_hash)
  end

  def test_second_hash_different
    hash2 = @first.to_hash
    hash2[:random] = :Type
    assert @first.hash != Parfait::Type.hash_code_for_hash( hash2 )
  end

  def test_add_is_different
    type = @first.add_instance_variable :random , :Integer
    assert type != @first , "new: #{type.inspect} , old: #{@first.inspect}"
    assert @first.hash != type.hash
  end

end
