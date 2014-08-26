module Register
  class ReturnImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodReturn
#        call = RegisterMachine.instance.call( code.method )
        block.replace(code , [] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after ReturnImplementation , CallImplementation 
end
