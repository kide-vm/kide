module Ruby

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Compilers or compiler passes are written by implementing methods.
  #
  class Statement

    # Many statements exist in the sol layer in quite a similar arrangement
    # Especially for different types of assignment we can abstract the creation
    # of the sol, by using the right class to instantiate, the "sol_brother"
    # Ie same class_name, but in the Sol module
    def sol_brother
      eval "Sol::#{class_name}"
    end

    # return the class name without the module
    # used to evaluate the sol_brother
    def class_name
      self.class.name.split("::").last
    end

    # helper method for formatting source code
    # depth is the depth in the tree (os the ast)
    # and the string are the ones to be indented (2 spaces)
    def at_depth(depth , lines)
      prefix = " " * 2 * depth
      strings = lines.split("\n")
      strings.collect{|str| prefix + str}.join("\n")
    end
  end
end
