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
  class BinaryCode < Object
    attribute :name

    include Indexed
    self.offset(2)

    def initialize name
      super()
      self.name = name
    end

    def to_s
      "BinaryCode #{self.name}"
    end

    def == other
      self.object_id == other.object_id
    end
  end
end
