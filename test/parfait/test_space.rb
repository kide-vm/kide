require_relative "helper"

module Parfait
  class TestSpace < ParfaitTest

    def classes
      [:BinaryCode,:Block,:CacheEntry,:Callable,:CallableMethod,:Class,
        :DataObject,:Data4,:Data8,:Data16,:Dictionary,:Factory, :Integer,:FalseClass,
        :List,:Message,:NamedList,:NilClass,:Object,:ReturnAddress,
        :Space,:TrueClass,:Type,:VoolMethod,:Word]
    end

    def test_space_length
      assert_equal 7 , @space.get_type.instance_length , @space.get_type.inspect
    end
    def test_singletons
      assert @space.true_object , "No truth"
      assert @space.false_object , "No lies"
      assert @space.nil_object , "No nothing"
    end
    def test_global_space
      assert_equal Parfait::Space , Parfait.object_space.class
    end
    def test_get_class_by_name
      assert_equal Parfait::Class , Parfait.object_space.get_class_by_name(:Space).class
    end
    def test_get_type_by_class_name
      assert_equal Parfait::Type , Parfait.object_space.get_type_by_class_name(:Space).class
    end
    def test_get_type_by_class_name_nil
      assert_nil Parfait.object_space.get_type_by_class_name(:Spac)
    end
    def test_classes_class
      classes.each do |name|
        assert_equal :Class , @space.classes[name].get_class.name
        assert_equal Parfait::Class , @space.classes[name].class
      end
    end
    def test_all_classes
      assert_equal classes.length , @space.classes.length , @space.classes.keys.inspect
    end
    def test_types
      assert  @space.instance_variable_ged("@types").is_a? Parfait::Dictionary
    end
    def test_types_attr
      assert @space.types.is_a? Parfait::Dictionary
    end
    def test_types_each
      @space.each_type do |type|
        assert type.is_a?(Parfait::Type)
      end
    end
    def test_types_hashes
      types = @space.instance_variable_ged("@types")
      types.each do |has , type|
        assert has.is_a?(Fixnum) , has.inspect
      end
    end
    def test_classes_types_in_space_types
      @space.classes do |name , clazz|
        assert_equal clazz.instance_type , @space.get_type_for(clazz.instance_type.hash) , clazz.name
      end
    end
    def test_word_class
      word = @space.classes[:Word]
      assert word.instance_type
      t_word = @space.get_type_for(word.instance_type.hash)
      assert_equal word.instance_type.hash , t_word.hash
      assert_equal word.instance_type.object_id , t_word.object_id
    end
    def test_classes_type
      classes.each do |name|
        assert_equal Parfait::Type , @space.classes[name].get_type.class
      end
    end
    def test_classes_name
      classes.each do |name|
        assert_equal name , @space.classes[name].name
      end
    end
    def test_method_name
      classes.each do |name|
        cl = @space.classes[name]
        cl.method_names.each do |mname|
          method = cl.get_instance_method(mname)
          assert_equal mname , method.name
          assert_equal name , method.for_class.name
        end
      end
    end
    def test_has_factory
      assert_equal Dictionary , @space.factories.class
    end
    def test_factory_length
      assert_equal 3 , @space.factories.length
    end
    def test_has_integer_factory
      ints = @space.get_factory_for(:Integer)
      assert_equal Factory , ints.class
      assert_equal :Integer , ints.for_type.class_name
    end
    def test_has_integers
      nekst = @space.get_next_for(:Integer)
      assert_equal Parfait::Integer , nekst.class
      assert_nil nekst.value
    end
    def test_has_next_integer
      nekst = @space.get_next_for(:Integer)
      nekst = @space.get_next_for(:Integer)
      assert_equal Parfait::Integer , nekst.class
    end
    def test_has_addresses
      ret = @space.get_next_for(:ReturnAddress)
      assert_equal Parfait::ReturnAddress , ret.class
      assert_nil ret.value
    end
    def test_has_next_address
      assert_equal Parfait::ReturnAddress , @space.get_next_for(:ReturnAddress).class
    end
    def test_address_count
      addr = @space.get_next_for(:ReturnAddress)
      count = 0
      while(addr)
        count += 1
        addr = addr.next_integer
      end
      assert_equal 1014, count
    end
    def test_has_message_factory
      ints = @space.get_factory_for(:Message)
      assert_equal Factory , ints.class
      assert_equal :Message , ints.for_type.class_name
    end
    def test_has_messages
      nekst = @space.get_next_for(:Message)
      assert_equal Parfait::Message , nekst.class
    end
    def test_has_next_message
      assert_equal Parfait::Message , @space.get_next_for(:Message).class
    end
    def test_message_count
      mess = @space.get_next_for(:Message)
      count = 0
      while(mess)
        count += 1
        assert mess.frame
        mess = mess.next_message
      end
      assert_equal 1014, count
    end
    def test_create_class
      assert @space.create_class( :NewClass )
    end

    def test_created_class_is_stored
      @space.create_class( :NewerClass )
      assert @space.get_class_by_name(:NewerClass)
    end

    def test_class_types_are_stored
      @space.classes.each do |name,clazz|
        assert @space.get_type_for(clazz.instance_type.hash)
      end
    end

    def test_class_types_are_identical
      @space.classes.each do |name , clazz|
        cl_type = @space.get_type_for(clazz.instance_type.hash)
        assert_equal cl_type.object_id , clazz.instance_type.object_id
      end
    end

    def test_remove_methods
      @space.each_type do | type |
        type.method_names.each do |method|
          type.remove_method(method)
        end
      end
      assert_equal 0 , @space.get_all_methods.length
    end
    def test_no_methods_in_types
      test_remove_methods
      @space.each_type do |type|
        assert_equal 0 , type.methods_length , "name #{type.name}"
      end
    end
    def test_no_methods_in_classes
      test_remove_methods
      @space.classes.each do |name , cl|
        assert_equal 0 , cl.instance_type.methods_length , "name #{cl.name}"
      end
    end
  end
end
