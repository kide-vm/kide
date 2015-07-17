module Register

  # "Boot" the virtual machine at the function given
  # meaning jump to that function currently. Maybe better to do some machine setup
  # and possibly some cleanup/exit has to tie in, but that is not this day

  class MainImplementation
    def run block
      block.codes.dup.each do |code|
        next unless code.is_a? Virtual::VirtualMain
        branch = Register::Branch.new( code.method.source.blocks.first )
        block.replace(code , branch )
      end
    end
  end
  Virtual.machine.add_pass "Register::MainImplementation"
end
