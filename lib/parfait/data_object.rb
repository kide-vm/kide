#
#
# In rubyx everything truely is an object. (most smalltalk/ruby systems use a union
# for integers/pointers that are called objects, but are really very different)
#
# Objects have type as their first member. No exception.
#
# So where is the data? In DataObjects. DataObjects are opague carriers of data.
# Opague to rubyx that is. There is no way to get at it or pass the data around.
#
# To use Data, Risc instructions have to be used. Luckily there is not soo much one
# actually wants to do with data, moving it between DataObject , comparing and
# logical and math operation that are bundled into the OperatorInstruction.
#
# For safe access the access code needs to know the length of the data, which is
# encoded in the class/type name. Ie An Integer derives from Data4, which is 4 long
# ( one for the type, one for the next, one word for the integer and currently still a marker)
#
# DataObjects still have a type, and so can have objects before the data starts
#
# A marker class
module Parfait
  class DataObject < Object
    def initialize
      super
    end
    def self.integer_index
      type_length
    end
    def self.type_length
      raise "called #{self}"
    end
    def padded_length
      self.class.memory_size * 4
    end
    def data_length
      self.class.memory_size
    end
  end

  class Data4 < DataObject
    def self.memory_size
      4
    end
  end
  class Data8 < DataObject
    def self.memory_size
      8
    end
  end
  class Data16 < DataObject
    def self.memory_size
      16
    end
  end
  class Data32 < DataObject
    def self.memory_size
      32
    end
  end
end
