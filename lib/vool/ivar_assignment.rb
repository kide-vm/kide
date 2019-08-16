module Vool

  class IvarAssignment < Assignment

    def to_s(depth = 0)
      at_depth(depth,"@#{super(0)}")
    end

    # We return the position where the local is stored. This is an array, giving the
    # position relative to :message- A SlotLoad is constructed from this.
    #
    # As we know it is a instance variable, it is stored in the :receiver , and has
    # the name @name
    def slot_position( compiler )
      [ :receiver , @name]
    end

  end
end
