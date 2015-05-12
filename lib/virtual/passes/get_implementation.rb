module Virtual
  # This implements instance variable get (not the opposite of Set, such a thing does not exists, their slots)

  # Ivar get needs to acces the layout, find the index of the name, and shuffle the data to return register
  # In short it's so complicated we implement it in ruby and stick the implementation here
  class GetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::InstanceGet
        raise "Start coding"
      end
    end
  end
  Virtual::Machine.instance.add_pass "Virtual::GetImplementation"
end
