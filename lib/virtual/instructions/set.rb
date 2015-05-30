module Virtual

  # class for Set instructions, A set is basically a mem move.
  # to and from are indexes into the known objects(frame,message,self and new_message),
  # these are represented as slots  (see there)
  # from may be a Constant (Object,Integer,String,Class)
  class Set < Instruction
    def initialize to , from
      @to = to
      # hard to find afterwards where it came from, so ensure it doesn't happen
      raise "From must be slot or constant, not symbol #{from}" if from.is_a? Symbol
      @from = from
    end
    attr_reader :from , :to
  end
end
