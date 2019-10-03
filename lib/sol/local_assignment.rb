module Sol

  # Local assignment really only differs in where the variable is actually stored,
  # slot_position defines that
  class LocalAssignment < Assignment

    # We return the position where the local is stored. This is an array, giving the
    # position relative to :message- A SlotLoad is constructed from this.
    #
    # Only snag is that we do not know this position, as only the compiler knows
    # if the variable name is a local or an arg. So we delegate to the compiler.
    def slot_position( compiler )
      slot = compiler.slot_type_for(@name)
      #puts "SLOT= #{slot}"
      slot
    end

  end

end
