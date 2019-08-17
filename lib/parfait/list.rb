# A List, or rather an ordered list, is just that, a list of items.

#
# For the implementation we use Objects memory which is index addressable
# But, objects are also lists where indexes start with 0, except 0 is taken for the Type
# so all incoming/outgoing indexes have to be shifted two up/down (one more for length)

module Parfait
  class List < Data16
    attr :type, :indexed_length , :next_list

    def self.type_length
      3    # 0 type , 1 length , 2 - next_list
    end
    def self.data_length
      self.memory_size - self.type_length - 1
    end

    def initialize
      super
      self.indexed_length = 0
    end

    def data_length
      self.class.data_length
    end
    def get_length
      r = indexed_length
      r.nil? ? 0 : r
    end

    def ensure_next
      self.next_list = List.new unless next_list
      self.next_list
    end

    # set the value at index.
    # Lists start from index 0
    def set( index , value)
      raise "Only positive indexes #{index}" if index < 0
      if index >= get_length
        grow_to(index + 1)
      end
      if index >= data_length
        ensure_next
        next_list.set( index - data_length , value)
      else
        set_internal_word( index + self.class.type_length, value)
      end
    end

    # set the value at index.
    # Lists start from index 0
    def get( index )
      raise "Only positive indexes, #{index}" if index < 0
      if index >= data_length
        return nil unless next_list
        return next_list.get( index - data_length)
      else
        ret = nil
        if(index < get_length)
          ret = get_internal_word(index + self.class.type_length )
        end
        return ret
      end
    end
    alias :[] :get

    def grow_to( len )
      raise "Only positive lenths, #{len}" if len < 0
      old_length = get_length
      return if old_length >= len
      internal_set_length( len)
    end

    def shrink_to( len )
      raise "Only positive lenths, #{len}" if len < 0
      old_length = get_length
      return if old_length <= len
      internal_set_length( len)
    end

    # def indexed_length
    #   get_length()
    # end

    # include? means non nil index
    def include?( item )
      return index_of(item) != nil
    end

    # index of item
    # return  nil if no such item
    def index_of( item )
      max = self.get_length
      #puts "length #{max} #{max.class}"
      counter = 0
      while( counter < max )
        if( get(counter) == item)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # return the next of given. Nil if item not in list or there is not next
    def next_value(val)
      index = index_of(val)
      return nil unless index
      return nil if index == (get_length - 1)
      return get(index + 1)
    end

    # push means add to the end
    # this automatically grows the List
    def push( value )
      to = self.get_length
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
      get(0)
    end

    def last
      return nil if empty?
      get(get_length() - 1)
    end

    def empty?
      self.get_length == 0
    end

    def equal?  other
      # this should call parfait get_class, alas that is not implemented yet
      return false if other.class != self.class
      return false if other.get_length != self.get_length
      index = self.get_length
      while(index >= 0)
        return false if other.get(index) != self.get(index)
        index = index - 1
      end
      return true
    end

    # above, correct, implementation causes problems in the machine object space
    # because when a second empty (newly created) list is added, it is not actually
    # added as it exists already. TODO, but hack with below identity function
    def ==( other )
      self.object_id == other.object_id
    end

    # word length (padded) is the amount of space taken by the object
    # For your basic object this means the number of instance variables as determined by type
    # This is off course 0 for a list, unless someone squeezed an instance variable in
    # but additionally, the amount of data comes on top.
    # unfortuntely we can't just use super because of the Padding
    def padded_length
      Object.padded_words( get_type().instance_length +  get_length() )
    end

    def each
      index = 0
      while index < self.get_length
        item = get(index)
        yield item
        index = index + 1
      end
      self
    end

    def each_with_index
      index = 0
      while index < self.get_length
        item = get(index)
        yield item , index
        index = index + 1
      end
      self
    end

    def each_pair
      index = 0
      while index < self.get_length
        key = get( index  )
        value = get(index + 1)
        yield key , value
        index = index + 2
      end
      self
    end

    def find
      index = 0
      while index < self.get_length
        item = get(index)
        return item if yield item
        index = index + 1
      end
      return nil
    end

    def set_length( len )
      was = self.get_length
      return if was == len
      if(was < len)
        grow_to( len )
      else
        shrink_to( len )
      end
    end

    def inspect
      index = 0
      ret = ""
      while index < self.get_length
        item = get(index)
        ret += item.inspect
        ret += "," unless index == (self.get_length - 1)
        index = index + 1
      end
      ret
    end

    def to_rxf_node(writer , level , ref )
      Sof.array_to_rxf_node(self , writer , level , ref )
    end

    def dup
      list = List.new
      each do |item|
        list.push(item)
      end
      list
    end

    def to_s
      res = "["
      each do |item|
        res = res + item.to_s
        res = res + " ,"
      end
      res = res + " ]"
      return res
    end
    def to_a
      array = []
      index = 0
      while( index < self.get_length)
        array[index] = get(index)
        index = index + 1
      end
      array
    end
    private
    def internal_set_length( i )
      self.indexed_length = i
    end
  end

end
