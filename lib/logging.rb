# a simple module to be included into a class that want to log
#
# use the standard logger and the class name as the program name
#
# The standard functions are available on the log object
# And the log level may be set after inclusion with level function (that takes symbols)

require "logger"

module Logging
  def self.included(base)
    base.extend(Methods)
  end
  def log
    self.class.log
  end

  module Methods
    def log
      return @logger if @logger
      @logger = Logger.new STDOUT
      @logger.progname = self.name.split("::").last
      @logger.datetime_format = '%M:%S'
      @logger.level = Logger::INFO
      @logger
    end
    def log_level l
      log.level = case l
                    when :unknown
                      Logger::UNKNOWN
                    when :fatal
                      Logger::FATAL
                    when :error
                      Logger::ERROR
                    when :warn
                      Logger::WARN
                    when :info
                      Logger::INFO
                    when :debug
                      Logger::DEBUG
                    else
                      raise "unknown log level #{l}"
                    end
    end
  end
end
