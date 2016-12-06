# Values are _not_ objects. Specifically they have the following properties not found in objects:
# - they are immutable
# - equality implies identity == is ===
# - they have type, not class

# To make them useful in an oo system, we assign a class to each value type
# This makes them look more like objects, but they are not.

# Value is an abstract class that unifies the "has a type" concept
# Types are not "objectified", but are represented as symbol constants

module Parfait
  class Value
  end
end
