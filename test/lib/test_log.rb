require_relative '../helper'

class MemLogger
  def self.stream
    @stream
  end
  def self.log_stream
    @stream = StringIO.new
  end
  include Logging
end

class LoggerTest < MiniTest::Test

  def setup
    @logger = MemLogger.new
  end

  def test_debug
    assert @logger.log.debug "Debug"
  end
  def test_info
    assert @logger.log.info "Info"
    assert MemLogger.stream.string.include? "Info"
  end
  def test_warn
    assert @logger.log.warn "Warn"
    assert MemLogger.stream.string.include? "Warn"
  end
  def test_error
    assert @logger.log.error "Error"
    assert MemLogger.stream.string.include? "Error"
  end
  def test_set_level
    [:unknown, :fatal, :error , :warn,  :info].each do |level|
      assert MemLogger.log_level( level)
    end
  end
end
