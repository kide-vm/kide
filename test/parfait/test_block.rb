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
    def test_block_hash_name
      assert_equal  :meth_block , @method.create_block( @args , @frame ).name
    end
    def test_type_name
      assert_equal 6 , @method.create_block( @args , @frame ).get_type.variable_index(:name)
    end
  end
end
