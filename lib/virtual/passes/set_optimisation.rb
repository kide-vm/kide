module Virtual

  class SetOptimisation
    def run block
      block.codes.dup.each_with_index do |code , i|
        next unless code.is_a? Virtual::Set
        next_code = block.codes[i+1]
        next unless next_code.is_a? Virtual::Set
        next unless code.to == next_code.from
        # TODO: a correct implementation would have to check that the code.to
        #       is not used in further blocks, before being assigned to
        new_code = Virtual::Set.new(code.from , next_code.to )
        block.replace(code , [new_code] )
        block.replace(next_code , [] )
      end
    end
  end
  Virtual.machine.add_pass "Virtual::SetOptimisation"
end
