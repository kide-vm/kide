require_relative "values"

module Vm
  
  # Think flowcharts: blocks are the boxes. The smallest unit of linear code
  
  # Blocks must end in control instructions (jump/call/return). 
  # And the only valid argument for a jump is a Block 
  
  # Blocks form a linked list
  
  # There are four ways for a block to get data (to work on)
  # - hard coded constants (embedded in code)
  # - memory move
  # - values passed in (from previous blocks. ie local variables)

  # See Value description on how to create code/instructions
  
  # Codes then get assembled into bytes (after linking)
  
  class Block < Code

    def initialize(name)
      super()
      @name = name.to_sym
      @next = nil
      @codes = []
    end

    attr_reader :name  , :next , :codes

    def length
      @codes.inject(0) {| sum  , item | sum + item.length}
    end

    def add_code(kode)
      if kode.is_a? Hash
        raise "Hack only for 1 element #{inspect} #{kode.inspect}" unless kode.length == 1
        instruction , result = kode.first
        instruction.result = result
        kode = instruction
      end
      raise "alarm #{kode}" if kode.is_a? Word
      raise "alarm #{kode}" unless kode.is_a? Code
      @codes << kode
      self
    end
    alias :<< :add_code 
    alias :a :add_code 

    def link_at pos , context
      @position = pos
      @codes.each do |code|
        code.link_at(pos , context)
        pos += code.length
      end
      pos
    end

    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
    end
    
    # to use the assignment syntax (see method_missing) the scope must be set, so variables can be resolved
    # The scope you set should be a binding (literally, the kernel.binding)
    # The function return the block, so it can be chained into an assignment
    #  Example (coding a function )  and having variable int defined
    #  b = function.body.scope(binding)
    #  b.int = 5                      will create a mov instruction to set the register that int points to 
    def scope where
      @scope = where
      self
    end
    # set the next executed block after self.
    # why is this useful? if it's unconditional, why not merge them:
    #    So the second block can be used as a jump target. You standard loop needs a block to setup
    #    and at least one to do the calculation
    def set_next block
      @next = block
    end

    # sugar to create instructions easily. Actually just got double sweet with two versions:
    # 1 for any method that ends in = we evaluate the method name in the current scope (see scope())
    #     for the result we call assign with the right value. The resulting instruction is added to 
    #     the block.
    #     Thus we emulate assignment, 
    #     Example: block b
    #                      b.variable = value          looks like what it does, but actually generates
    #                                                   an instruction for the block (mov or add)
    #                   
    # 2- any other method will be passed on to the CMachine and the result added to the block
    #  With this trick we can write what looks like assembler, 
    #  Example   b.instance_eval
    #                mov( r1 , r2 )
    #                add( r1 , r2 , 4)
    # end
    #           mov and add will be called on Machine and generate Inststuction that are then added 
    #             to the block
    def method_missing(meth, *args, &block)
      if( meth.to_s[-1] == "=" && args.length == 1)
        l_val = @scope.eval  meth.to_s[0 ... -1]
        add_code l_val.asign(args[0])
      end
      add_code CMachine.instance.send(meth , *args)
    end

  end

end