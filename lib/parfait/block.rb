module Parfait

  # A Block is a callable object, much like a CallableMethod.
  # Surprisingly similar in fact, as the block is really only missing the name.
  #
  # The difference lies mostly in the way they are compiled
  #
  # Also both have a list of blocks defined in their scope. But this is
  # notimplemented for blocks yet
  #
  class Block < Callable

    def ==(other)
      return false unless other.is_a?(Block)
      super
    end

    def inspect
      "#{self_type.object_class.name}(#{arguments_type.inspect})"
    end
  end
end
