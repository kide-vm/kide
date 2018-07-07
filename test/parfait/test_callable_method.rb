require_relative "helper"

module Parfait
  class TestMethod < ParfaitTest

    def setup
      super
      make_method
    end

    def test_method_name
      assert_equal :meth , @method.name
    end

    def test_class_for
      assert_equal :Object , @method.self_type.object_class.name
    end

    def test_arg1
      assert_equal 3 , @method.arguments_type.get_length , @method.arguments_type.inspect
      assert_equal Symbol , @method.arguments_type.names.first.class
      assert_equal :bar , @method.arguments_type.name_at(1)
    end

    def test_has_argument
      assert_equal 1 , @method.arguments_type.variable_index(:bar)
      assert_equal 2 , @method.arguments_type.variable_index(:foo)
    end

    def test_add_arg
      @method.arguments_type.send( :private_add_instance_variable, :foo2 , :Object)
      assert_equal 4 , @method.arguments_type.get_length
      assert_equal :foo2 , @method.arguments_type.name_at(3)
      assert_equal :Object , @method.arguments_type.type_at(3)
    end

    def test_get_arg_name1
      index = @method.arguments_type.variable_index(:bar)
      assert_equal 1 , index
      assert_equal :bar , @method.arguments_type.name_at(index)
    end
    def test_get_arg_type1
      index = @method.arguments_type.variable_index(:bar)
      assert_equal :Integer , @method.arguments_type.type_at(index)
    end
    def test_get_arg_name2
      index = @method.arguments_type.variable_index(:foo)
      assert_equal 2 , index
      assert_equal :foo , @method.arguments_type.name_at(index)
    end
    def test_get_arg_type2
      index = @method.arguments_type.variable_index(:foo)
      assert_equal :Type , @method.arguments_type.type_at(index)
    end

    def test_local1
      assert_equal 3 , @method.frame_type.get_length , @method.frame_type.inspect
      assert_equal Symbol , @method.frame_type.names.first.class
      assert_equal :local_bar , @method.frame_type.name_at(1)
    end

    def test_has_local
      assert_equal 1 , @method.has_local(:local_bar)
      assert_equal 2 , @method.has_local(:local_foo)
    end

    def test_add_local
      @method.add_local(:foo2 , :Object)
      assert_equal 4 , @method.frame_type.get_length
      assert_equal :foo2 , @method.frame_type.name_at(3)
      assert_equal :Object , @method.frame_type.type_at(3)
    end

    def test_get_locals_name1
      index = @method.has_local(:local_bar)
      assert_equal 1 , index
      assert_equal :local_bar , @method.frame_type.name_at(index)
    end
    def test_get_frame_type1
      index = @method.has_local(:local_bar)
      assert_equal :Integer , @method.frame_type.type_at(index)
    end
    def test_get_locals_name2
      index = @method.has_local(:local_foo)
      assert_equal 2 , index
      assert_equal :local_foo , @method.frame_type.name_at(index)
    end
    def test_get_frame_type2
      index = @method.has_local(:local_bar)
      assert_equal :Integer , @method.frame_type.type_at(index)
    end
    def test_created_with_binary
      assert @method.binary
    end
    def test_equal
      assert_equal @method , @method
    end
    def test_not_equal
      method = Parfait::CallableMethod.new( @obj , :other , @args , @frame)
      assert @method != method
    end
  end
end
