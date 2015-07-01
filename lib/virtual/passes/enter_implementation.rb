module Virtual

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        new_codes = []
        # save return register to the message at instance return_address
        new_codes << Register.save_return(:message , :return_address)
        # set the method instance on message, have to load first
        tmp = Register.tmp_reg
        new_codes << Register::LoadConstant.new( code.method , tmp )
        new_codes << Register.set_slot( tmp , :message  , :method)
        # and create a new frame if needed
        unless code.method.locals.empty? and code.method.tmps.empty?
          new_codes << Virtual::NewFrame.new
        end
        block.replace(code , new_codes )
      end
    end
  end
  Virtual.machine.add_pass "Virtual::EnterImplementation"
end
