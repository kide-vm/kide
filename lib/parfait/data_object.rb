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
# encoded in the class/type name. Ie An Integer derives from Data2, which is 2 long
# (minus one for the type, so exactly the one word for the integer)
#
# DataObjects still have a type, and so can have objects before the data starts
#
# A marker class
module Parfait
  class DataObject < Object
    def initialize
      @memory = []
    end
    def data_length
      raise "called #{self}"
    end
    def data_start
      return type.length
    end

    # 1 -based index
    def get_internal_word(index)
      @memory[index]
    end

    # 1 -based index
    def set_internal_word(index , value)
      raise "Word[#{index}] = nil" if( value.nil? )
      @memory[index] = value
      value
    end
  end

  class Data2 < DataObject
    def data_length
      1
    end
  end

  class Data8 < DataObject
    def data_length
      7
    end
  end
  class Data16 < DataObject
    def data_length
      15
    end
  end
end
