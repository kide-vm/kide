module Register

  # A label is a placeholder for it's next Instruction
  # It's function is not to turn into code, but to be a valid brnch target
  #
  # So branches and Labels are pairs, fan out, fan in
  #
  #

  class Label < Instruction
    def initialize source , name , nekst = nil
      super(source , nekst)
      @name = name
    end
    attr_reader :name

    def to_s
      "Label: #{@name} (#{self.next.class})"
    end

    def to_ac labels = []
      return [] if labels.include?(self)
      labels << self
      self.next.to_ac(labels)
    end

    def length labels = []
      return 0 if labels.include?(self)
      labels << self
      1 + self.next.length(labels)
    end

  end
end
