require_relative "helper"

module Parfait
  class TestObject < ParfaitTest

    def setup
      super
      @object = ::Parfait::Object.new
    end

    def test_empty_object_doesnt_return
      assert_nil @object.get_internal_word(3)
    end

    def test_one_set1
      assert_equal @object.get_type ,  @object.set_internal_word(0, @object.get_type)
    end

  end
end
