require_relative "helper"

module Parfait
  class TestListTooMany < ParfaitTest
    def setup
      super
      @list = ::Parfait::List.new
      @list.data_length.times { |i| @list.push i.to_s }
    end
    def add_two
      @list.push(@list.data_length.to_s)
      @list.push((@list.data_length + 1).to_s)
    end
    def test_next
      assert_nil @list.next_list
    end
    def test_setup_len
      assert_equal List.data_length , @list.get_length
    end
    def test_setup_last
      assert_equal (List.data_length - 1).to_s , @list.last
    end
    def test_length_two
      add_two
      assert_equal List.data_length + 2 , @list.get_length
    end
    def test_get_last
      add_two
      assert_equal (List.data_length + 1).to_s , @list.last
    end
    def test_get_but_last
      add_two
      assert_equal List.data_length.to_s , @list[List.data_length]
    end
  end
end
