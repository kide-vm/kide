module Mom

  # A base class for conditions in MOM
  # Just a marker, no real functionality for now

  class Check < Instruction

  end

  # The funny thing about the ruby truth is that is is anything but false or nil
  #
  # To implement the normal ruby logic, we check for false or nil and jump
  # to the false branch. true_block follows implicitly
  #
  class TruthCheck < Check
    attr_reader :condition

    def initialize(condition)
      @condition  = condition
    end

    def to_risc(compiler)
      Risc::Label.new(self,"nosense")
    end

  end
end
