module Risc
  # simulate memory during compile time.
  #
  # Memory comes in chunks, power of 2 chunks actually.
  #
  # Currently typed instance variables map to ruby instance variables and so do not
  # end up in memory. Memory being only for indexed word aligned access.
  #
  # Parfait really does everything else, apart from the internal_get/set
  # And our fake memory (other than hte previously used array, does bound check)
  class FakeMemory
    attr_reader :min
    def initialize(from , size)
      @min = from
      @memory = Array.new(size)
      raise "only multiples of 2 !#{size}" unless size == 2**(Math.log2(size).to_i)
    end
    def set(index , value)
      range_check(index)
      @memory[index] = value
      value
    end
    alias :[]=  :set

    def get(index)
      range_check(index)
      @memory[index]
    end
    alias :[] :get

    def size
      @memory.length
    end

    def range_check(index)
      raise "index too low #{index} < #{min}" if index < min
      raise "index too big #{index} < #{min}" if index >= size
    end
  end
end
