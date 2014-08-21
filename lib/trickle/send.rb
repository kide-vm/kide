module Trickle
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class Send
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? MessageSend
         
      end
    end
  end
end
