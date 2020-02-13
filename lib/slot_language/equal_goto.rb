module SlotLanguage
  class EqualGoto
    attr_reader  :left , :right, :goto

    def initialize( left , right)
      @left = left
      @right = right
    end
    def set_goto(go)
      @goto = go
    end
  end
end
