module Register
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class GetImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::InstanceGet
        raise "Start coding"
      end
    end
  end
  Virtual::Object.space.add_pass_after GetImplementation, Virtual::SendImplementation
end
