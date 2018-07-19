module Ruby
  class HashStatement
    attr_reader :hash

    def initialize(  )
      @hash = {}
    end

    def add(key , value)
      @hash[key] = value
    end

    def length
      @hash.length
    end
  end
end
