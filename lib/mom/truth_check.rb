require_relative "check"

module Mom

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
  end
end
