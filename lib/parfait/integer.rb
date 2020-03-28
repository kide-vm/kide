  # Integer class for representing maths on Integers
  # Integers are Objects, specifically DataObjects
  # - they have fixed value
  # - they are immutable fo rthe most part (or to the user)
  #
module Parfait
  class Integer < Data4

    attr_reader :next_integer

    def self.type_length
      2    # 0 type, 1 next_i
    end
    # index at which the next integer reference is. Used in risc reneration
    def self.next_index
      1
    end
    # index at which the actual integer is. Used in risc reneration
    def self.integer_index
      type_length
    end

    def initialize(value , next_i = nil)
      super()
      @next_integer = next_i
      set_internal_word(Integer.integer_index, value)
    end

    def value
      get_internal_word(Integer.integer_index)
    end

    def to_s
      "Integer " + value.to_s
    end
    # compile time method to set the actual value.
    # this should not really be part of parfait, as ints are immutable at runtime.
    def set_value(value)
      set_internal_word(Integer.integer_index, value)
    end

    def _set_next_integer(nekst)
      @next_integer = nekst
    end
    # :integer?, :odd?, :even?, :upto, :downto, :times, :succ, :next, :pred, :chr, :ord, :to_i, :to_int, :floor,
    # :ceil, :truncate, :round, :gcd, :lcm, :gcdlcm, :numerator, :denominator, :to_r, :rationalize,
    # :singleton_method_added, :coerce, :i, :+, :-, :fdiv, :div, :divmod, :%, :modulo, :remainder, :abs, :magnitude,
    # :real?, :zero?, :nonzero?, :step, :quo, :to_c, :real, :imaginary, :imag, :abs2, :arg, :angle, :phase,
    # :rectangular, :rect, :polar, :conjugate, :conj, :>, :>=, :<, :<=, :between?
    #
    # Numeric
    # :singleton_method_added, :coerce, :i, :+, :-, :fdiv, :div, :divmod, :%, :modulo, :remainder, :abs, :magnitude,
    # :to_int, :real?, :integer?, :zero?, :nonzero?, :floor, :ceil, :round, :truncate, :step, :numerator, :denominator,
    # :quo, :to_c, :real, :imaginary, :imag, :abs2, :arg, :angle, :phase, :rectangular, :rect, :polar, :conjugate, :conj,
    # :>, :>=, :<, :<=, :between?
  end

  # Marker class. Same functionality as Integer
  # (ie carrying an int, the return address)
  #
  # But the integer (address) needs to be adjusted by load address.
  class ReturnAddress < Integer

    def to_s(ignored = nil)
      "ReturnAddress 0x" + object_id.to_s(16) + ":" + value.to_s
    end
  end

  # adding other base classes in here for now:
  class FalseClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
      set_internal_word( Integer.integer_index , 0 )
    end
    def self.type_length
      1    # 0 type
    end
  end
  class TrueClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
      set_internal_word( Integer.integer_index , 1 )
    end
    def self.type_length
      1    # 0 type
    end
  end
  class NilClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
      set_internal_word( Integer.integer_index , 0 )
    end
    def self.type_length
      1    # 0 type
    end
  end
end
