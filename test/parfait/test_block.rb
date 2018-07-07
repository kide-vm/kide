require_relative "helper"

module Parfait
  class TestBlock < ParfaitTest

    def setup
      super
      make_method
    end

    def test_make_block
      assert_equal Block , @method.create_block(@args , @frame ).class
    end

    def test_block_type
      assert_equal @method.self_type , @method.create_block(@args , @frame ).self_type
    end

    def test_block_in_method
      assert @method.has_block( @method.create_block(@args , @frame ))
    end

  end
end
