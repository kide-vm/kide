# A List, or rather an ordered list, is just that, a list of items.

# For a programmer this may be a little strange as this new start goes with trying to break old
# bad habits. A List would be an array in some languages, but list is a better name, closer to
# common language.
# Another bad habit is to start a list from 0. This is "just" programmers lazyness, as it goes
# with the standard c implementation. But it bends the mind, and in oo we aim not to.
# If you have a list of three items, they will be first, second and third, ie 1,2,3
#
# For the implementation we use Objects memory which is index addressable
# But, objects are also lists where indexes start with 1, except 1 is taken for the Type
# so all incoming/outgoing indexes have to be shifted one up/down

module Parfait
  class List < Object
    def self.get_length_index
      2
    end
    def self.get_indexed(index)
      index + 2
    end

    def get_offset
        2
    end

    def get_length
      r = get_internal_word( 2 ) #one for type
      r.nil? ? 0 : r
    end

    # set the value at index.
    # Lists start from index 1
    def set( index , value)
      raise "Only positive indexes #{index}" if index <= 0
      if index > get_length
        grow_to(index)
      end
      # start one higher than offset, which is where the length is
      set_internal_word( index + 2, value)
    end

    # set the value at index.
    # Lists start from index 1
    def get( index )
      raise "Only positive indexes, #{index}" if index <= 0
      ret = nil
      if(index <= get_length)
        # start one higher than offset, which is where the length is
        ret = get_internal_word(index + 2 )
      end
      ret
    end

    def grow_to( len)
      raise "Only positive lenths, #{len}" if len < 0
      old_length = get_length
      return if old_length >= len
      #          raise "bounds error at #{len}" if( len + offset > 16 )
      # be nice to use the indexed_length , but that relies on booted space
      set_internal_word( 2  , len) #one for type
    end

    def shrink_to( len )
      raise "Only positive lenths, #{len}" if len < 0
      old_length = get_length
      return if old_length <= len
      set_internal_word( 2  , len)
    end

    def indexed_length
      get_length()
    end

    def initialize(  )
      super()
      @memory = []
    end

    # include? means non nil index
    def include?  item
      return index_of(item) != nil
    end

    # index of item, remeber first item has index 1
    # return  nil if no such item
    def index_of( item )
      max = self.get_length
      #puts "length #{max} #{max.class}"
      counter = 1
      while( counter <= max )
        if( get(counter) == item)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # push means add to the end
    # this automatically grows the List
    def push( value )
      to = self.get_length + 1
      set( to , value)
      to
    end

    def delete( value )
      index = index_of value
      return false unless index
      delete_at index
    end

    def delete_at( index )
      # TODO bounds check
      while(index < self.get_length)
        set( index , get(index + 1))
        index = index + 1
      end
      set_length( self.get_length - 1)
      true
    end

    def first
      return nil if empty?
      get(1)
    end

    def last
      return nil if empty?
      get(get_length())
    end

    def empty?
      self.get_length == 0
    end

    def equal?  other
      # this should call parfait get_class, alas that is not implemented yet
      return false if other.class != self.class
      return false if other.get_length != self.get_length
      index = self.get_length
      while(index > 0)
        return false if other.get(index) != self.get(index)
        index = index - 1
      end
      return true
    end

    # above, correct, implementation causes problems in the machine object space
    # because when a second empty (newly created) list is added, it is not actually
    # added as it exists already. TODO, but hack with below identity function
    def ==   other
      self.object_id == other.object_id
    end

    # word length (padded) is the amount of space taken by the object
    # For your basic object this means the number of instance variables as determined by type
    # This is off course 0 for a list, unless someone squeezed an instance variable in
    # but additionally, the amount of data comes on top.
    # unfortuntely we can't just use super because of the Padding
    def padded_length
      padded_words( get_type().instance_length +  get_length() )
    end

    def each
      index = 1
      while index <= self.get_length
        item = get(index)
        yield item
        index = index + 1
      end
      self
    end

    def each_with_index
      index = 1
      while index <= self.get_length
        item = get(index)
        yield item , index
        index = index + 1
      end
      self
    end

    def each_pair
      index = 1
      while index <= self.get_length
        key = get( index  )
        value = get(index + 1)
        yield key , value
        index = index + 2
      end
      self
    end

    def find
      index = 1
      while index <= self.get_length
        item = get(index)
        return item if yield item
        index = index + 1
      end
      return nil
    end

    def set_length  len
      was = self.get_length
      return if was == len
      if(was < len)
        grow_to len
      else
        shrink_to len
      end
    end

    def inspect
      index = 1
      ret = ""
      while index <= self.get_length
        item = get(index)
        ret += item.inspect
        ret += "," unless index == self.get_length
        index = index + 1
      end
      ret
    end

    # 1 -based index
    def get_internal_word(index)
      @memory[index]
    end

    # 1 -based index
    def set_internal_word(index , value)
      raise "Word[#{index}] = " if((self.class == Parfait::Word) and value.nil? )
      @memory[index] = value
      value
    end

    alias :[] :get

    def to_sof_node(writer , level , ref )
      Sof.array_to_sof_node(self , writer , level , ref )
    end

    def dup
      list = List.new
      each do |item|
        list.push(item)
      end
      list
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
