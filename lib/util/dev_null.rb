module Util
  # A class that does not write, or swallows all incoming data
  # Used in Arm to do a dry run (and in testing, where it was born)
  class DevNull
    def write_unsigned_int_32( _ );end
  end
end
