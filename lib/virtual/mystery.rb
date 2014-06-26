module Virtual
  class Mystery < Value
    def initilize 
    end

    def as type
      type.new
    end

  end
end
