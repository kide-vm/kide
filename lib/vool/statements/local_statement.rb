module Vool

  class LocalAssignment < Assignment
    # used to collect frame information
    def add_local( array )
      array << @name
    end

    def to_mom( method )
      if method.args_type.variable_index(@name)
        type = :arguments
      else
        type = :frame
      end
      Mom::SlotConstant.new([:message , type , @name] , @value)
    end
  end

end
