
class Array < Object
  #many basic array functions can not be defined in ruby, such as
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
