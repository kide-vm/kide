module SlotLanguage
  class CheckMaker
    attr_reader :check , :left , :right, :goto

    def initialize(check , left , right)
      @check = check
      @left = left
      @right = right
    end
    def set_goto(go)
      @goto = go
    end
  end
end
