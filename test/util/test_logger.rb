require "util/logging"
module Util

  class LoggerTest < MiniTest::Test
    include Util::Logging
    log_level :info

    def test_debug
      self.log.debug "Just good to know"
    end
    def test_unknown
      self.log.debug "Whats this"
    end
  end
end
