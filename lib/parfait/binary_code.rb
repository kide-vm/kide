# A method object is a description of the method, it's name etc
#
# But the code that the method represents, the binary, is held as an array
# in one of these.
#
# The BinaryCode is really just a name to make sure that when we call a method
# it is really the code we call.

module Parfait
  # obviously not a "Word" but a ByteArray , but no such class yet
  # As on the other hand has no encoding (yet) it is close enough
  class BinaryCode < Word
    def initialize name
      super(0)
      @name = name
    end
    attr_reader :name
    
    # this is a sof check if there are instance variables or "structure"
    # have to override false, as word answers true
    def is_value?
      false
    end
    def to_s
      "BinaryCode #{@name}"
    end
  end
end
