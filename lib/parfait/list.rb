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
    self.offset(0)

    def initialize(  )
      super()
    end

    alias :[] :get


    def each
      # not sure how to do this with define_method, because of the double block issue.
      # probably some clever way around that, but not important
      index = 1
      while index <= self.get_length
        item = get(index)
        yield item
        index = index + 1
      end
      self
    end

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
