# almost simplest hash imaginable. make good use of Lists

module Parfait
  class Dictionary < Object

    attr_reader :type, :i_keys , :i_values

    def self.type_length
      3
    end

    # only empty initialization for now
    #
    # internally we store keys and values in lists, which means this does **not** scale well
    def initialize
      super()
      @i_keys = List.new()
      @i_values = List.new()
    end

    def keys
      @i_keys.dup
    end

    def values
      @i_values.dup
    end

    # are there any key/value items in the list
    def empty?
      @i_keys.empty?
    end

    # How many key/value pairs there are
    def length()
      return @i_keys.get_length()
    end

    def next_value(val)
      return @i_values.next_value(val)
    end

    # get a value fot the given key
    # key identity is checked with == not === (ie equals not identity)
    # return nil if no such key
    def get(key)
      index = key_index(key)
      if( index )
        @i_values.get(index)
      else
        nil
      end
    end

    # same as get(key)
    def [](key)
      get(key)
    end

    # private method
    def key_index(key)
      @i_keys.index_of(key)
    end

    # set key with value, returns value
    def set(key , value)
      index = key_index(key)
      if( index )
        @i_values.set(index , value)
      else
        @i_keys.push(key)
        @i_values.push(value)
      end
      value
    end

    #same as set(k,v)
    def []=(key,val)
      set(key,val)
    end

    # yield to each key value pair
    def each
      index = 0
      while index < @i_keys.get_length
        key = @i_keys.get(index)
        value = @i_values.get(index)
        yield key , value
        index = index + 1
      end
      self
    end

    def inspect
      string = "Dictionary{"
      each do |key , value|
        string += key.to_s + " => " + value.to_s + " ,"
      end
      string + "}"
    end

    def to_rxf_node(writer , level , ref)
      Sof.hash_to_rxf_node( self , writer , level , ref)
    end
  end
end
