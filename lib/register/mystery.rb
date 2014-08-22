module Register
  class Mystery < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initilize reg
      super
    end
  end
end
