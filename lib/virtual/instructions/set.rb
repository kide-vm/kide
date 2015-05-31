module Virtual

  # class for Set instructions, A set is basically a mem move.
  # to and from are indexes into the known objects(frame,message,self and new_message),
  # these are represented as slots  (see there)
  # from may be a Constant (Object,Integer,String,Class)
  class Set < Instruction
    def initialize to , from
      @to = to
      @from = from
    end
    attr_reader :from , :to
  end
end
