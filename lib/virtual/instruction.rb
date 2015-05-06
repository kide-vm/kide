require_relative "object"

module Virtual

  # Instruction is an abstract for all the code of the object-machine.
  # Derived classes make up the actual functionality of the machine.
  # All functions on the machine are captured as instances of instructions
  #
  # It is actually the point of the virtual machine layer to express oo functionality in the set of instructions,
  # thus defining a minimal set of instructions needed to implement oo.

  # This is partly because jumping over this layer and doing in straight in assember was too big a step
  class Instruction < Virtual::Object

    # simple thought: don't recurse for Blocks, just check their names
    def == other
      return false unless other.class == self.class
      Sof::Util.attributes(self).each do |a|
        begin
          left = send(a)
        rescue NoMethodError
          next  # not using instance variables that are not defined as attr_readers for equality
        end
        begin
          right = other.send(a)
        rescue NoMethodError
          return false
        end
        return false unless left.class == right.class
        if( left.is_a? Block)
          return false unless left.name == right.name
        else
          return false unless left == right
        end
      end
      return true
    end
  end

end

require_relative "instructions/branch"
require_relative "instructions/halt"
require_relative "instructions/instance_get"
require_relative "instructions/message_send"
require_relative "instructions/method_call"
require_relative "instructions/method_enter"
require_relative "instructions/method_return"
require_relative "instructions/new_frame"
require_relative "instructions/new_message"
require_relative "instructions/set"
