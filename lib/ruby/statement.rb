module Ruby

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Compilers or compiler passes are written by implementing methods.
  #
  class Statement

    def at_depth(depth , *strings)
      prefix = " " * 2 * depth
      strings.collect{|str| prefix + str}.join("\n")
    end

  end

  class Expression

    def to_vool
      raise "should not be normalized #{self}"
    end

  end

end
