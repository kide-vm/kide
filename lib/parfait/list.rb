
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

    def initialize(  )
      super()
    end

    def get_length
      internal_object_length - 1
    end

    # index of item, remeber first item has index 1
    # return  nil if no such item
    def index_of( item )
      max = self.get_length
      counter = 1
      while( counter <= max )
        if( get(counter) == item)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # include? means non nil index
    def include? item
      return index_of(item) != nil
    end

    # push means add to the end
    # this automatically grows the List
    def push value
      self.set( self.get_length + 1 , value)
    end

    def delete value
      index = index_of value
      return false unless index
      delete_at index
    end

    def delete_at index
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

    # set the value at index.
    # Lists start from index 1
    def set( index , value)
      raise "Only positive indexes #{index}" if index <= 0
      if index > self.get_length
        grow_to(index)
      end
      # internally 1 is reserved for the layout
      internal_object_set( index + 1, value)
    end

    # set the value at index.
    # Lists start from index 1
    def get(index)
      raise "Only positive indexes, #{index}" if index <= 0
      if index > self.get_length
        return nil
      else
        return internal_object_get(index + 1)
      end
    end

    def empty?
      self.get_length == 0
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

    def set_length len
      was = self.get_length
      return if was == len
      if(was < len)
        grow_to len
      else
        shrink_to len
      end
    end

    def grow_to(len)
      raise "Only positive lenths, #{len}" if len < 0
      old_length = self.get_length
      return if old_length >= len
      internal_object_grow(len + 1)
    end

    def shrink_to(len)
      raise "Only positive lenths, #{len}" if len < 0
      old_length = self.get_length
      return if old_length <= len
      internal_object_shrink(len + 1)
    end

    def ==(other)
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
    def == other
      self.object_id == other.object_id
    end

    # word length (padded) is the amount of space taken by the object
    # For your basic object this means the number of instance variables as determined by layout
    # This is off course 0 for a list, unless someone squeezed an instance variable in
    # but additionally, the amount of data comes on top.
    # unfortuntely we can't just use super because of the Padding
    def word_length
      padded_words( get_layout().get_length() +  get_length() )
    end

    #many basic List functions can not be defined in ruby, such as
    # get/set/length/add/delete
    # so they must be defined as Methods in Builtin::Kernel

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
