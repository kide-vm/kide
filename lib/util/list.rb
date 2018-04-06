module Util
  module List

    # set the next instruction (also aliased as <<)
    # throw an error if that is set, use insert for that use case
    # return the instruction, so chaining works as one wants (not backwards)
    def set_next( nekst )
      raise "Next already set #{@next}" if @next
      @next = nekst
      nekst
    end

    # get the next instruction (without arg given )
    # when given an interger, advance along the line that many time and return.
    def next( amount = 1)
      (amount == 1) ? @next : @next.next(amount-1)
    end

    # set the give instruction as the next, while moving any existing
    # instruction along to the given ones's next.
    # ie insert into the linked list that the instructions form
    # but allowing the instruction to be a list too (ie more than one)
    def insert( instruction )
      instruction.last.set_next @next
      @next = instruction
    end

    # return last set instruction. ie follow the linked list until it stops
    def last
      code = self
      while( code.next )
        raise "Circular list #{code.class}:#{code}" if code == code.next
        code = code.next
      end
      return code
    end

    # set next for the last (see last)
    # so append the given code to the linked list at the end
    def append( code )
      last.set_next code
      self
    end
    alias :<< :append

    def length
      ret = 0
      self.each { ret += 1}
      ret
    end

    def each(&block)
      block.call(self)
      @next.each(&block) if @next
    end

  end
end
