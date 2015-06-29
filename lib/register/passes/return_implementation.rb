module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
        new_codes = []
        # move the current message to new_message
        new_codes << RegisterTransfer.new( Register.message_reg , Register.new_message_reg )
        # and restore the message from saved value in new_message
        new_codes << Register.get_slot(:new_message , :caller , :message )
        # "roll out" self and frame into their registers
        new_codes << Register.get_slot( :message , :receiver , :self )
        new_codes << Register.get_slot( :message , :frame , :frame )
        #load the return address into pc, affecting return. (other cpus have commands for this, but not arm)
        new_codes << FunctionReturn.new( Register.message_reg , Register.resolve_index(:message , :return_address) )
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Register::ReturnImplementation"
end
