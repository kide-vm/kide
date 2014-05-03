require "vm/machine"

module Arm
  class ArmMachine < Vm::Machine
    
    def word_load value
      "word"
    end
    def function_call call_value
      "call"
    end

    def main_entry
      e = Vm::Block.new("main_entry")
    end
    def main_exit
      e = Vm::Block.new("main_exit")
    end
  end
end