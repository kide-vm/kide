
# Integer class for representing maths on Integers
# Integers are Objects, specifically DataObjects
# - they have fixed value
# - they are immutable
# (both by implementation, not design.
# Ie it would be possible to change the value, we just don't support that)

module Parfait
  class Integer < Data4

    def initialize(value , next_i = nil)
      super()
      @next_integer = next_i
      set_internal_word(Integer.integer_index, value)
    end
    attr_reader :next_integer

    def value
      get_internal_word(Integer.integer_index)
    end

    def self.type_length
      2    # 0 type, 1 next_i
    end
    def self.integer_index
      type_length
    end

    # :integer?, :odd?, :even?, :upto, :downto, :times, :succ, :next, :pred, :chr, :ord, :to_i, :to_int, :floor,
    # :ceil, :truncate, :round, :gcd, :lcm, :gcdlcm, :numerator, :denominator, :to_r, :rationalize,
    # :singleton_method_added, :coerce, :i, :+@, :-@, :fdiv, :div, :divmod, :%, :modulo, :remainder, :abs, :magnitude,
    # :real?, :zero?, :nonzero?, :step, :quo, :to_c, :real, :imaginary, :imag, :abs2, :arg, :angle, :phase,
    # :rectangular, :rect, :polar, :conjugate, :conj, :>, :>=, :<, :<=, :between?
    #
    # Numeric
    # :singleton_method_added, :coerce, :i, :+@, :-@, :fdiv, :div, :divmod, :%, :modulo, :remainder, :abs, :magnitude,
    # :to_int, :real?, :integer?, :zero?, :nonzero?, :floor, :ceil, :round, :truncate, :step, :numerator, :denominator,
    # :quo, :to_c, :real, :imaginary, :imag, :abs2, :arg, :angle, :phase, :rectangular, :rect, :polar, :conjugate, :conj,
    # :>, :>=, :<, :<=, :between?
  end

  # adding other base classes in here for now:
  class FalseClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
    end
    def self.type_length
      1    # 0 type
    end
  end
  class TrueClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
    end
    def self.type_length
      1    # 0 type
    end
  end
  class NilClass < Data4
    #FIXME: this is "just" for compilation
    def initialize
      super
    end
    def self.type_length
      1    # 0 type
    end
  end
end
