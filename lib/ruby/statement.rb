module Ruby

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Compilers or compiler passes are written by implementing methods.
  #
  class Statement

    # Many statements exist in the vool layer in quite a similar arrangement
    # Especially for different types of assignment we can abstract the creation
    # of the vool, by using the right class to instantiate, the "vool_brother"
    # Ie same class_name, but in the Vool module
    def vool_brother
      eval "Vool::#{class_name}"
    end

    # return the class name without the module
    # used to evaluate the vool_brother
    def class_name
      self.class.name.split("::").last
    end

    # helper method for formatting source code
    # depth is the depth in the tree (os the ast)
    # and the string are the ones to be indented (2 spaces)
    def at_depth(depth , *strings)
      prefix = " " * 2 * depth
      strings.collect{|str| prefix + str}.join("\n")
    end
  end
end
