module Vool

  class LocalAssignment < Assignment
    # used to collect frame information
    def add_local( array )
      array << @name
    end

    def to_mom( method )
      Mom::SlotConstant.new([:message , :self , @name] , @value)
    end
  end

end
