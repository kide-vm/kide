
# A Page (from the traditional memory page) represents a collection of
# objects in a physically form. Ie the page holds the memory or data, that
# the objects are made up of.

# Pages have a total size, but more importantly an object size.
# All objects of a Page are same sized, and multiples of the smallest
# object. The smallest object is usually a cache line, 16 bytes or
# an exponent of two larger.

module Parfait
  class Page < Object

  end
end
