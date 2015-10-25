# various classes would derive from array in ruby, ie have indexed variables
#
# But for our memory layout we need the variable part of an object to be after
# the fixed, ie the instance variables
#
# Just using ruby derivation will not allow us to offset the index, so instead the
# function will be generated and included to the classes that need them.
#
# Using ruby include does not work for similar reasons, so Indexed.at is the main
# function that generates the methods
 # ( do have to use a marker module so we can test with is_a?)

module Parfait
  module Indexed # marker module
    def self.included(base)
      base.extend(Methods)
    end

    module Methods
      def offset( offset  )

        define_method  :get_length do
          internal_object_length - 1
        end

        # index of item, remeber first item has index 1
        # return  nil if no such item
        define_method  :index_of do |item|
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
        define_method  :include? do |item|
          return index_of(item) != nil
        end

        # push means add to the end
        # this automatically grows the List
        define_method  :push do |value|
          set( self.get_length + 1 , value)
        end

        define_method  :delete do |value|
          index = index_of value
          return false unless index
          delete_at index
        end

        define_method  :delete_at do |index|
          # TODO bounds check
          while(index < self.get_length)
            set( index , get(index + 1))
            index = index + 1
          end
          set_length( self.get_length - 1)
          true
        end


        define_method  :first do
          return nil if empty?
          get(1)
        end

        define_method  :last do
          return nil if empty?
          get(get_length())
        end

        # set the value at index.
        # Lists start from index 1
        define_method  :set do | index , value|
          raise "Only positive indexes #{index}" if index <= 0
          if index > self.get_length
            grow_to(index)
          end
          # internally 1 is reserved for the layout
          internal_object_set( index + 1, value)
        end

        # set the value at index.
        # Lists start from index 1
        define_method  :get do | index|
          raise "Only positive indexes, #{index}" if index <= 0
          if index > self.get_length
            return nil
          else
            return internal_object_get(index + 1)
          end
        end

        define_method  :empty? do
          self.get_length == 0
        end

        define_method  :set_length do | len|
          was = self.get_length
          return if was == len
          if(was < len)
            grow_to len
          else
            shrink_to len
          end
        end

        define_method  :grow_to do | len|
          raise "Only positive lenths, #{len}" if len < 0
          old_length = self.get_length
          return if old_length >= len
          internal_object_grow(len + 1)
        end

        define_method  :shrink_to do | len|
          raise "Only positive lenths, #{len}" if len < 0
          old_length = self.get_length
          return if old_length <= len
          internal_object_shrink(len + 1)
        end

        define_method  :equal? do | other|
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
        define_method  :== do | other|
          self.object_id == other.object_id
        end

        # word length (padded) is the amount of space taken by the object
        # For your basic object this means the number of instance variables as determined by layout
        # This is off course 0 for a list, unless someone squeezed an instance variable in
        # but additionally, the amount of data comes on top.
        # unfortuntely we can't just use super because of the Padding
        define_method  :word_length do
          padded_words( get_layout().get_length() +  get_length() )
        end

        define_method  :inspect do
          inspect_from 1
        end

        define_method  :inspect_from do |index|
          ret = ""
          while index <= self.get_length
            item = get(index)
            ret += item.inspect
            ret += "," unless index == self.get_length
            index = index + 1
          end
          ret
        end

      end
    end
  end
end
