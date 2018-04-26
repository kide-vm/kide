require_relative "helper"

module Parfait
  class TestAttributes < ParfaitTest

    def setup
      super
      @mess = @space.first_message
      @type = @mess.get_type
    end

    def test_message_get_type
      assert_equal Parfait::Type , @type.class
    end

    def test_message_name_nil
      last = @type.names.last
      assert_equal :arguments , last , @type.names.inspect
      assert_nil  @mess.name
    end
    def test_message_next_set
      @mess.next_message = :next_message
      assert_equal :next_message , @mess.next_message
    end
    def test_message_type_set
      @mess.set_type @type
      assert_equal @type , @mess.get_type
    end
    def test_attribute_index
      @mess.next_message = :message
      assert_equal Parfait::Type , @mess.get_type.class
    end

    def test_type_type
      assert_equal Parfait::Type , @type.get_type.get_type.class
    end
    def test_type_type_type
      assert_equal Parfait::Type , @type.get_type.get_type.get_type.class
    end
  end
end
