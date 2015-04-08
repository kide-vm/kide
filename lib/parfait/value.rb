# this is not a "normal" ruby file, ie it is not required by salama
# instead it is parsed by salama to define part of the program that runs

# Values are _not_ objects. Specifically they have the following properties not found in objects:
# - they are immutable
# - equality implies identity == is ===
# - they have type, not class

# To make them useful in an oo system, we assign a class to each basic type
# This makes them look more like objects, but they are not.

# Value is an abstract class that unifies the "has a type" concept
# Types are not "objectified", but are represented as integer constants

class Value

  # to make the machine work, the constants need
  # - to start at 0
  # - be unique
  # - be smaller enough to fit into the 2-4 bits available 
  INTEGER_VALUE = 0
  OBJECT_VALUE  = 1
  
  # the type is what identifies the value
  def get_type()
    raise "abstract clalled on #{self}"
  end

  # Get class works on the type. The value's type is stored by the machine.
  # So this function is not overriden in derived classes, because it is used
  # to espablish what class a value has! (it's that "fake" oo i mentioned)
  def get_class()
    type = self.get_type()
    return Integer if( type == INTEGER_VALUE )
    raise "invalid type"
  end
end
