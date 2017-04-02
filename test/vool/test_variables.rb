require_relative "../helper"

module Vool
  class TestVariables < MiniTest::Test

    # "free standing" local can not be tested as it will result in send
    # in other words ther is no way of knowing if a name is variable or method
    def ptest_send_to_local
      lst = Compiler.compile( "foo = 1 ; foo.bar")
      assert_equal LocalVariable , lst.receiver
    end

  end
end
