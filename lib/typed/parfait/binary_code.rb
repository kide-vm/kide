# A typed method object is a description of the method, it's name etc
#
# But the code that the method represents, the binary, is held as an array
# in one of these.
#

module Parfait
  # obviously not a "Word" but a ByteArray , but no such class yet
  # As our String (Word) on the other hand has no encoding (yet) it is close enough
  class BinaryCode < Word

    def to_s
      "BinaryCode #{self.char_length}"
    end

  end
end
