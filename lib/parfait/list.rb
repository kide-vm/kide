

module Parfait
  class List < Object

    def index_of( item )
      max = self.length
      counter = 0
      while( counter < max )
        if( internal_object_get(index) == item)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # push means add to the end
    # this automatically grows the List
    def push value
      self.set( length , value)
    end

    def set( index , value)
      raise "negative index for set #{len}" if index < 0
      if index >= self.length
        grow_to(index)
      end
      internal_object_set( index , value)
    end

    def get(index)
      raise "negative index for get #{len}" if index < 0
      if index >= self.length
        return nil
      else
        return internal_object_get(index)
      end
    end

    def empty?
      self.length == 0
    end

    def each
      index = 0
      while index < self.length
        item = get(index)
        yield item
        index = index + 1
      end
      self
    end
    def grow_to(len)
      raise "negative length for grow #{len}" if len < 0
      return unless len > self.length
      index = self.length
      internal_object_grow(length)
      while( index < self.length )
        internal_object_set( index , nil)
        index += 1
      end
    end
    #many basic List functions can not be defined in ruby, such as
    # get/set/length/add/delete
    # so they must be defined as CompiledMethods in Builtin::Kernel

    #ruby 2.1 list (just for reference, keep at bottom)
    # :at, :fetch, :first, :last, :concat, :<<, :push, :pop, :shift, :unshift, :insert, :each, :each_index, :reverse_each,
    # :length, :size, :empty?, :find_index, :index, :rindex, :join, :reverse, :reverse!, :rotate, :rotate!,
    # :sort, :sort!, :sort_by!, :collect, :collect!, :map, :map!, :select, :select!, :keep_if,
    # :values_at, :delete, :delete_at, :delete_if, :reject, :reject!, :zip, :transpose, :replace, :clear,
    # :fill, :include?, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :uniq, :uniq!, :compact, :compact!,
    # :flatten, :flatten!, :count, :shuffle!, :shuffle, :sample, :cycle, :permutation, :combination,
    # :repeated_permutation, :repeated_combination, :product, :take, :take_while, :drop, :drop_while,
    # :bsearch, :pack, :entries, :sort_by, :grep, :find, :detect, :find_all, :flat_map, :collect_concat,
    # :inject, :reduce, :partition, :group_by, :all?, :any?, :one?, :none?,
    # :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry,
    # :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :lazy

  end
end
