module Trickle
  # This implements the send logic
  # Send is so complicated that we actually code it in ruby and stick it in
  # That off course opens up an endless loop possibility that we stop by reducing to Class and Module methods
  class Send
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MessageSend
        puts "Found me a send #{code.me.type}"
        if( code.me.type == Virtual::Reference)
          next
        end
      end
    end
  end
end
