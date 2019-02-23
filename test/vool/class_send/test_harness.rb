require_relative "helper"

module Vool
  class ClassSendHarness < MiniTest::Test
    include MomCompile
    include ClassHarness

    def send_method
      "Object.get_internal_word(0)"
    end

  end
end
