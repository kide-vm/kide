# Copied logger from logger gem.
# removed monitor for opal
# rmoevd shifting and file options

# == Description
#
# The Logger class provides a simple but sophisticated logging utility that
# you can use to output messages.
#
# The messages have associated
# levels, such as +INFO+ or +ERROR+ that indicate their importance.
# You can then give the Logger a level, and only messages at that
# level of higher will be printed.
#
# The levels are:
#
# +FATAL+:: an unhandleable error that results in a program crash
# +ERROR+:: a handleable error condition
# +WARN+::  a warning
# +INFO+::  generic (useful) information about system operation
# +DEBUG+:: low-level information for developers
#
# For instance, in a production system, you may have your Logger set to
# +INFO+ or even +WARN+
# When you are developing the system, however, you probably
# want to know about the program's internal state, and would set the Logger to
# +DEBUG+.
#
# *Note*: Logger does not escape or sanitize any messages passed to it.
# Developers should be aware of when potentially malicious data (user-input)
# is passed to Logger, and manually escape the untrusted data:
#
#   logger.info("User-input: #{input.dump}")
#   logger.info("User-input: %p" % input)
#
# You can use #formatter= for escaping all data.
#
#   original_formatter = Logger::Formatter.new
#   logger.formatter = proc { |severity, datetime, progname, msg|
#     original_formatter.call(severity, datetime, progname, msg.dump)
#   }
#   logger.info(input)
#
# === Example
#
# This creates a logger to the standard output stream, with a level of +WARN+
#
#   log = Logger.new(STDOUT)
#   log.level = Logger::WARN
#
#   log.debug("Created logger")
#   log.info("Program started")
#   log.warn("Nothing to do!")
#
#   begin
#     File.each_line(path) do |line|
#       unless line =~ /^(\w+) = (.*)$/
#         log.error("Line in wrong format: #{line}")
#       end
#     end
#   rescue => err
#     log.fatal("Caught exception; exiting")
#     log.fatal(err)
#   end
#
# Because the Logger's level is set to +WARN+, only the warning, error, and
# fatal messages are recorded.  The debug and info messages are silently
# discarded.
#
# === Features
#
# There are several interesting features that Logger provides, like
# auto-rolling of log files, setting the format of log messages, and
# specifying a program name in conjunction with the message.  The next section
# shows you how to achieve these things.
#
#
# == HOWTOs
#
# === How to create a logger
#
# The options below give you various choices, in more or less increasing
# complexity.
#
# 1. Create a logger which logs messages to STDERR/STDOUT.
#
#      logger = Logger.new(STDERR)
#      logger = Logger.new(STDOUT)
#
# 2. Create a logger for the file which has the specified name.
#
#      logger = Logger.new('logfile.log')
#
# 3. Create a logger for the specified file.
#
#      file = File.open('foo.log', File::WRONLY | File::APPEND)
#      # To create new (and to remove old) logfile, add File::CREAT like;
#      #   file = open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
#      logger = Logger.new(file)
#
# 4. Create a logger which ages logfile once it reaches a certain size.  Leave
#    10 "old log files" and each file is about 1,024,000 bytes.
#
#      logger = Logger.new('foo.log', 10, 1024000)
#
# 5. Create a logger which ages logfile daily/weekly/monthly.
#
#      logger = Logger.new('foo.log', 'daily')
#      logger = Logger.new('foo.log', 'weekly')
#      logger = Logger.new('foo.log', 'monthly')
#
# === How to log a message
#
# Notice the different methods (+fatal+, +error+, +info+) being used to log
# messages of various levels?  Other methods in this family are +warn+ and
# +debug+.  +add+ is used below to log a message of an arbitrary (perhaps
# dynamic) level.
#
# 1. Message in block.
#
#      logger.fatal { "Argument 'foo' not given." }
#
# 2. Message as a string.
#
#      logger.error "Argument #{ @foo } mismatch."
#
# 3. With progname.
#
#      logger.info('initialize') { "Initializing..." }
#
# 4. With severity.
#
#      logger.add(Logger::FATAL) { 'Fatal error!' }
#
# The block form allows you to create potentially complex log messages,
# but to delay their evaluation until and unless the message is
# logged.  For example, if we have the following:
#
#     logger.debug { "This is a " + potentially + " expensive operation" }
#
# If the logger's level is +INFO+ or higher, no debug messages will be logged,
# and the entire block will not even be evaluated.  Compare to this:
#
#     logger.debug("This is a " + potentially + " expensive operation")
#
# Here, the string concatenation is done every time, even if the log
# level is not set to show the debug message.
#
# === How to close a logger
#
#      logger.close
#
# === Setting severity threshold
#
# 1. Original interface.
#
#      logger.sev_threshold = Logger::WARN
#
# 2. Log4r (somewhat) compatible interface.
#
#      logger.level = Logger::INFO
#
#      DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
#
#
# == Format
#
# Log messages are rendered in the output stream in a certain format by
# default.  The default format and a sample are shown below:
#
# Log format:
#   SeverityID, [Date Time mSec #pid] SeverityLabel -- ProgName: message
#
# Log sample:
#   I, [Wed Mar 03 02:34:24 JST 1999 895701 #19074]  INFO -- Main: info.
#
#
# Or, you may change the overall format with #formatter= method.
#
#   logger.formatter = proc do |severity, datetime, progname, msg|
#     "#{datetime}: #{msg}\n"
#   end
#   # e.g. "Thu Sep 22 08:51:08 GMT+9:00 2005: hello world"
#
module Util
  class Logger
    VERSION = "1.2.8"
    ProgName = "#{File.basename(__FILE__)}/#{VERSION}"

    # Logging severity.
    module Severity
      # Low-level information, mostly for developers
      DEBUG = 0
      # generic, useful information about system operation
      INFO = 1
      # a warning
      WARN = 2
      # a handleable error condition
      ERROR = 3
      # an unhandleable error that results in a program crash
      FATAL = 4
      # an unknown message that should always be logged
      UNKNOWN = 5
    end
    include Severity

    # Logging severity threshold (e.g. <tt>Logger::INFO</tt>).
    attr_accessor :level

    # program name to include in log messages.
    attr_accessor :progname


    # Logging formatter, as a +Proc+ that will take four arguments and
    # return the formatted message. The arguments are:
    #
    # +severity+:: The Severity of the log message
    # +time+:: A Time instance representing when the message was logged
    # +progname+:: The #progname configured, or passed to the logger method
    # +msg+:: The _Object_ the user passed to the log message; not necessarily a String.
    #
    # The block should return an Object that can be written to the logging device via +write+.  The
    # default formatter is used when no formatter is set.
    attr_accessor :formatter

    alias sev_threshold level
    alias sev_threshold= level=

    # Returns +true+ iff the current severity level allows for the printing of
    # +DEBUG+ messages.
    def debug?; @level <= DEBUG; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +INFO+ messages.
    def info?; @level <= INFO; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +WARN+ messages.
    def warn?; @level <= WARN; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +ERROR+ messages.
    def error?; @level <= ERROR; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +FATAL+ messages.
    def fatal?; @level <= FATAL; end

    #
    # === Synopsis
    #
    #   Logger.new(name)
    #   Logger.new(name)
    #
    # === Args
    #
    # +logdev+::
    #   The log device.  This is a filename (String) or IO object (typically
    #   +STDOUT+, +STDERR+, or an open file).
    #
    # === Description
    #
    # Create an instance.
    #
    def initialize(logdev)
      @progname = nil
      @level = DEBUG
      @default_formatter = Formatter.new
      @formatter = nil
      @logdev = nil
      if logdev
        @logdev = LogDevice.new(logdev)
      end
    end

    #
    # === Synopsis
    #
    #   Logger#add(severity, message = nil, progname = nil) { ... }
    #
    # === Args
    #
    # +severity+::
    #   Severity.  Constants are defined in Logger namespace: +DEBUG+, +INFO+,
    #   +WARN+, +ERROR+, +FATAL+, or +UNKNOWN+.
    # +message+::
    #   The log message.  A String or Exception.
    # +progname+::
    #   Program name string.  Can be omitted.  Treated as a message if no
    #   +message+ and +block+ are given.
    # +block+::
    #   Can be omitted.  Called to get a message string if +message+ is nil.
    #
    # === Return
    #
    # +true+ if successful, +false+ otherwise.
    #
    # When the given severity is not high enough (for this particular logger), log
    # no message, and return +true+.
    #
    # === Description
    #
    # Log a message if the given severity is high enough.  This is the generic
    # logging method.  Users will be more inclined to use #debug, #info, #warn,
    # #error, and #fatal.
    #
    # <b>Message format</b>: +message+ can be any object, but it has to be
    # converted to a String in order to log it.  Generally, +inspect+ is used
    # if the given object is not a String.
    # A special case is an +Exception+ object, which will be printed in detail,
    # including message, class, and backtrace.  See #msg2str for the
    # implementation if required.
    #
    # === Bugs
    #
    # * Logfile is not locked.
    # * Append open does not need to lock file.
    # * If the OS which supports multi I/O, records possibly be mixed.
    #
    def add(severity, message = nil, progname = nil, &block)
      severity ||= UNKNOWN
      if @logdev.nil? or severity < @level
        return true
      end
      progname ||= @progname
      if message.nil?
        if block_given?
  	       message = yield
        else
  	      message = progname
  	      progname = @progname
        end
      end
      @logdev.write(
        format_message(format_severity(severity), Time.now, progname, message))
      true
    end
    alias log add

    #
    # Dump given message to the log device without any formatting.  If no log
    # device exists, return +nil+.
    #
    def <<(msg)
      unless @logdev.nil?
        @logdev.write(msg)
      end
    end

    #
    # Log a +DEBUG+ message.
    #
    # See #info for more information.
    #
    def debug(progname = nil, &block)
      add(DEBUG, nil, progname, &block)
    end

    #
    # :call-seq:
    #   info(message)
    #   info(progname,&block)
    #
    # Log an +INFO+ message.
    #
    # +message+:: the message to log; does not need to be a String
    # +progname+:: in the block form, this is the #progname to use in the
    #              the log message.  The default can be set with #progname=
    # <tt>&block</tt>:: evaluates to the message to log.  This is not evaluated
    #                   unless the logger's level is sufficient
    #                   to log the message.  This allows you to create
    #                   potentially expensive logging messages that are
    #                   only called when the logger is configured to show them.
    #
    # === Examples
    #
    #   logger.info("MainApp") { "Received connection from #{ip}" }
    #   # ...
    #   logger.info "Waiting for input from user"
    #   # ...
    #   logger.info { "User typed #{input}" }
    #
    # You'll probably stick to the second form above, unless you want to provide a
    # program name (which you can do with #progname= as well).
    #
    # === Return
    #
    # See #add.
    #
    def info(progname = nil, &block)
      add(INFO, nil, progname, &block)
    end

    #
    # Log a +WARN+ message.
    #
    # See #info for more information.
    #
    def warn(progname = nil, &block)
      add(WARN, nil, progname, &block)
    end

    #
    # Log an +ERROR+ message.
    #
    # See #info for more information.
    #
    def error(progname = nil, &block)
      add(ERROR, nil, progname, &block)
    end

    #
    # Log a +FATAL+ message.
    #
    # See #info for more information.
    #
    def fatal(progname = nil, &block)
      add(FATAL, nil, progname, &block)
    end

    #
    # Log an +UNKNOWN+ message.  This will be printed no matter what the logger's
    # level.
    #
    # See #info for more information.
    #
    def unknown(progname = nil, &block)
      add(UNKNOWN, nil, progname, &block)
    end

    #
    # Close the logging device.
    #
    def close
      @logdev.close if @logdev
    end

  private

    # Severity label for logging. (max 5 char)
    SEV_LABEL = %w(DEBUG INFO WARN ERROR FATAL ANY)

    def format_severity(severity)
      SEV_LABEL[severity] || 'ANY'
    end

    def format_message(severity, datetime, progname, msg)
      (@formatter || @default_formatter).call(severity, datetime, progname, msg)
    end


    # Default formatter for log messages
    class Formatter
      def call(severity, time, progname, msg)
        "#{severity} #{progname} #{time.strftime("%M-%S-%L")}::#{msg2str(msg)}\n"
      end

    private

      def msg2str(msg)
        case msg
        when ::String
          msg
        when ::Exception
          "#{ msg.message } (#{ msg.class })\n" <<
            (msg.backtrace || []).join("\n")
        else
          msg.inspect
        end
      end
    end


    # Device used for logging messages.
    class LogDevice
      attr_reader :dev
      attr_reader :filename

      def initialize(log)
        @dev = log
      end

      def write(message)
        @dev.write(message)
      end

      def close
        begin
          @dev.close rescue nil
        rescue Exception
          @dev.close rescue nil
        end
      end

    private

      SiD = 24 * 60 * 60


      def eod(t)
        Time.mktime(t.year, t.month, t.mday, 23, 59, 59)
      end
    end
  end
end
