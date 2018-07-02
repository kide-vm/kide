require_relative "../helper"

module Parfait
  class TypeMessages < ParfaitTest

    def setup
      super
      @mess = @space.next_message
    end

    def test_message_type
      type = @mess.get_type
      assert type
      assert @mess.instance_variable_defined :next_message
      assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
    end

    def test_message_by_index
      assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
      index = @mess.get_type.variable_index :next_message
      assert_equal 1 , index
      assert_equal @mess.next_message , @mess.get_internal_word(index)
    end

    def test_type_methods
      assert_equal 4 , @mess.get_type.get_type.variable_index(:methods)
    end

  end
end
