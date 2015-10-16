module Virtual

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        new_codes = []
        # save return register to the message at instance return_address
        new_codes << Register.save_return(code, :message , :return_address)
        # and create a new frame if needed
        unless code.method.locals.empty?
          new_codes <<  Register.get_slot( code, :message , :frame , Register.resolve_to_register(:frame))
        end
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Virtual::EnterImplementation"
end
