require_relative "../helper"

module Risc
  class Dummy
    def padded_length
      4
    end
    def byte_length
      4
    end
  end
  class DummyInstruction < Dummy
    include Util::List
    def initialize(nekst = nil)
      @next = nekst
    end
  end
end
