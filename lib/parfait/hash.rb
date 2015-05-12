# almost simplest hash imaginable. make good use of arrays

module Parfait
  class Hash < Object
    def initialize
      @keys = Array.new_object()
      @values = Array.new_object()
    end
    def values()
      @values
    end
    def keys()
      @keys
    end
    def empty?
      @keys.empty?
    end

    def length()
      return @keys.length()
    end

    def get(key)
      index = key_index(key)
      if( index )
        @values[index]
      else
        nil
      end
    end
    def [](key)
      get(key)
    end

    def key_index(key)
      len = @keys.length()
      index = 0
      found = nil
      while(index < len)
        if( @keys[index] == key)
          found = index
          break
        end
        index += 1
      end
      found
    end

    def set(key , value)
      index = key_index(key)
      if( index )
        @keys[index] = value
      else
        @keys.push(key)
        @values.push(value)
      end
      value
    end
    def []=(key,val)
      set(key,val)
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
