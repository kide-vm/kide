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

    def initialize(name , function , next_block = nil)
      super()
      @function = function
      @name = name.to_sym
      @next = next_block
      @codes = []
      @insert_at_end = false
    end

    attr_reader :name  , :next , :codes , :function

    def add_code(kode)
      if kode.is_a? Hash
        raise "Hack only for 1 element #{inspect} #{kode.inspect}" unless kode.length == 1
        instruction , result = kode.first
        instruction.assign result
        kode = instruction
      end
      raise "alarm #{kode}" if kode.is_a? Word
      raise "alarm #{kode}" unless kode.is_a? Code
      insert_at.codes << kode
      self
    end
    alias :<< :add_code 
    alias :a :add_code 

    # create a new linear block after this block. Linear means there is no brach needed from this one
    # to the new one. Usually the new one just serves as jump address for a control statement
    # In code generation (assembly) , new new_block is written after this one, ie zero runtime cost
    def new_block name
      new_b = Block.new( name , @function , @next )
      @next = new_b
      return new_b
    end

    # when control structures create new blocks (with new_block) control continues at the end of
    # the chain of blocks that was created.
    # the code using _this block should be unaware of the complexity of the block and just keep using this
    # block as before (ie in a linear way)
    # this switches that behaviour on, ie code is hence after inserted at the end of the last block
    def insert_at_end
      @insert_at_end = true
      self
    end

    # returns the point at which code is added. See insert_at_end for explanation. Usually self, but... 
    def insert_at
      return self unless @insert_at_end 
      @next ? @next.insert_at : self
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

    # sugar to create instructions easily. Actually just got double sweet with two versions:
    # 1 for any method that ends in = we evaluate the method name in the current scope (see scope())
    #     for the result we call assign with the right value. The resulting instruction is added to 
    #     the block.
    #     Thus we emulate assignment, 
    #     Example: block b
    #                      b.variable = value          looks like what it does, but actually generates
    #                                                   an instruction for the block (mov or add)
    #                   
    # 2- any other method will be passed on to the RegisterMachine and the result added to the block
    #  With this trick we can write what looks like assembler, 
    #  Example   b.instance_eval
    #                mov( r1 , r2 )
    #                add( r1 , r2 , 4)
    # end
    #           mov and add will be called on Machine and generate Inststuction that are then added 
    #             to the block
    def method_missing(meth, *args, &block)
      var = meth.to_s[0 ... -1]
      if( args.length == 1) and  ( meth.to_s[-1] == "=" )
        if @scope.local_variable_defined? var.to_sym
          l_val = @scope.local_variable_get var.to_sym
          return add_code l_val.assign(args[0])
        else
          return super
        end
      end
      add_code RegisterMachine.instance.send(meth , *args)
    end

    # Code interface follows. Note position is inheitted as is from Code

    # length of the block is the length of it's codes, plus any next block (ie no branch follower)
    #  Note, the next is in effect a linked list and as such may have many blocks behind it.
    def length
      cods = @codes.inject(0) {| sum  , item | sum + item.length}
      cods += @next.length if @next
      cods
    end

    # to link we link the codes (instructions), plus any next in line block (non- branched)
    def link_at pos , context
      super(pos , context)
      @codes.each do |code|
        code.link_at(pos , context)
        pos += code.length
      end
      if @next
        @next.link_at pos , context
        pos += @next.length
      end
      pos
    end

    # assemble the codes (instructions) and any next in line block
    def assemble(io)
      @codes.each do |obj|
        obj.assemble io
      end
      @next.assemble(io) if @next
    end
  end
end