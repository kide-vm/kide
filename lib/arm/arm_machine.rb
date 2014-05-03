require "vm/machine"

module Arm
  class ArmMachine < Vm::Machine
    
    def word_load value
      "word"
    end
    def function_call call_value
      "call"
    end
  end
end