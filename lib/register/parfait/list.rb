require_relative "indexed"
# A List, or rather an ordered list, is just that, a list of items.

# For a programmer this may be a little strange as this new start goes with trying to break old
# bad habits. A List would be an array in some languages, but list is a better name, closer to
# common language.
# Another habit is to start a list from 0. This is "just" programmers lazyness, as it goes
# with the standard c implementation. But it bends the mind, and in oo we aim not to.
# If you have a list of three items, you they will be first, second and third, ie 1,2,3
#
# For the implementation we use Objects memory which is index addressable
# But, objects are also lists where indexes start with 1, except 1 is taken for the Layout
# so all incoming/outgoing indexes have to be shifted one up/down

module Parfait
  class List < Object
    include Indexed
    self.offset(1)

    def initialize(  )
      super()
    end

    alias :[] :get

    def to_sof_node(writer , level , ref )
      Sof.array_to_sof_node(self , writer , level , ref )
    end
    def to_a
      array = []
      index = 1
      while( index <= self.get_length)
        array[index - 1] = get(index)
        index = index + 1
      end
      array
    end
  end

  # new list from ruby array to be precise
  def self.new_list array
    list = Parfait::List.new
    list.set_length array.length
    index = 1
    while index <= array.length do
      list.set(index , array[index - 1])
      index = index + 1
    end
    list
  end

end
