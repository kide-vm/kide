require_relative "../helper"

class TestSpace < MiniTest::Test

  def setup
    @machine = Register.machine.boot
  end
  def classes
    [:Kernel,:Word,:List,:Message,:Frame,:Type,:Object,:Class,:Dictionary,:Method , :Integer]
  end
  def test_booted
    assert_equal true , @machine.booted
  end
  def test_machine_space
    assert_equal Parfait::Space , @machine.space.class
  end
  def test_global_space
    assert_equal Parfait::Space , Parfait::Space.object_space.class
  end
  def test_integer
    int = Parfait::Space.object_space.get_class_by_name :Integer
    assert_equal 3, int.method_names.get_length
  end

  def test_classes_class
    classes.each do |name|
      assert_equal :Class , @machine.space.classes[name].get_class.name
      assert_equal Parfait::Class , @machine.space.classes[name].class
    end
  end

  def test_types
    assert  @machine.space.types.is_a? Parfait::Dictionary
  end
  
  def test_classes_type
    classes.each do |name|
      assert_equal Parfait::Type , @machine.space.classes[name].get_type.class
    end
  end

  def test_classes_name
    classes.each do |name|
      assert_equal name , @machine.space.classes[name].name
    end
  end

  def test_method_name
    classes.each do |name|
      cl = @machine.space.classes[name]
      cl.method_names.each do |mname|
        method = cl.get_instance_method(mname)
        assert_equal mname , method.name
        assert_equal name , method.for_class.name
      end
    end
  end
  def test_messages
    mess = @machine.space.first_message
    all = []
    while mess
      all << mess
      assert mess.frame
      mess = mess.next_message
    end
    assert_equal all.length , all.uniq.length
    # there is a 5.times in space, but one Message gets created before
    assert_equal  50 + 1 , all.length
  end
  def test_message_vars
    mess = @machine.space.first_message
    all = mess.get_instance_variables
    assert all
    assert all.include?(:next_message)
  end

end
