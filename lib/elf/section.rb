module Elf
  class Section
    def initialize(name)
      @name = name
    end
    attr_accessor :name, :index

    def type
      raise 'Reimplement #type'
    end
    def flags
      0
    end
    def addr
      0
    end
    def link
      0
    end
    def info
      0
    end
    def alignment
      1
    end
    def ent_size
      0
    end
  end
  
end
