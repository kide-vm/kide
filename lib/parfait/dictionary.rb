# almost simplest hash imaginable. make good use of Lists

module Parfait
  class Dictionary < Object
    attribute :keys
    attribute  :values
    # only empty initialization for now
    #
    # internally we store keys and values in lists, which means this does **not** scale well
    def initialize
      super()
      self.keys = List.new()
      self.values = List.new()
    end

    # are there any key/value items in the list
    def empty?
      self.keys.empty?
    end

    # How many key/value pairs there are
    def length()
      return self.keys.get_length()
    end

    # get a value fot the given key
    # key identity is checked with == not === (ie equals not identity)
    # return nil if no such key
    def get(key)
      index = key_index(key)
      if( index )
        self.values.get(index)
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
      len = self.keys.get_length()
      index = 1
      found = nil
      while(index <= len)
        if( self.keys.get(index) == key)
          found = index
          break
        end
        index += 1
      end
      found
    end

    # set key with value, returns value
    def set(key , value)
      index = key_index(key)
      if( index )
        self.keys.set(index , value)
      else
        self.keys.push(key)
        self.values.push(value)
      end
      value
    end

    #same as set(k,v)
    def []=(key,val)
      set(key,val)
    end

    # yield to each key value pair
    def each
      index = 1
      while index <= self.keys.get_length
        key = self.keys.get(index)
        value = self.values.get(index)
        yield key , value
        index = index + 1
      end
      self
    end

    # :rehash, :to_hash, :to_h, :to_a, :[], :fetch, :[]=, :store, :default, :default=, :default_proc, :default_proc=,
    # :key, :index, :size, :length, :empty?, :each_value, :each_key, :each_pair, :each, :keys, :values,
    # :values_at, :shift, :delete, :delete_if, :keep_if, :select, :select!, :reject, :reject!, :clear, :invert,
    # :update, :replace, :merge!, :merge, :assoc, :rassoc, :flatten, :include?, :member?, :has_key?, :has_value?,
    # :key?, :value?, :compare_by_identity, :compare_by_identity?, :entries, :sort, :sort_by, :grep, :count, :find,
    # :detect, :find_index, :find_all, :collect, :map, :flat_map, :collect_concat, :inject, :reduce, :partition,
    # :group_by, :first, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :each_with_index,
    # :reverse_each, :each_entry, :each_slice, :each_cons, :each_with_object, :zip, :take, :take_while, :drop, :drop_while,
    # :cycle, :chunk, :slice_before, :lazy
  end
end
