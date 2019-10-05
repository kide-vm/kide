module SlotLanguage
  class SlotMaker
    attr_reader :name , :leaps

    def initialize(name , more)
      @name = name
      if(more.is_a?(Array))
        @leaps = more
      else
        @leaps = [more] if more
      end
    end

    def add_slot_name(name)
      if(@leaps)
        @leaps << name
      else
        @leaps = [name]
      end
    end
  end
end
