module Register

  class EnterImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::MethodEnter
        # save return register and create a new frame
        block.replace(code , [] )
      end
    end
  end
  Virtual::BootSpace.space.add_pass_after EnterImplementation , CallImplementation
end
