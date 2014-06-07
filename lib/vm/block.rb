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
      @insert_at = self
      # keeping track of register usage, left (assigns) or right (uses)
      @assigns = []
      @uses = []
    end

    attr_reader :name  , :next , :codes , :function , :assigns , :uses

    def add_code(kode)
      raise "alarm #{kode}" if kode.is_a? Word
      raise "alarm #{kode.class} #{kode}" unless kode.is_a? Code
      @assigns += kode.assigns
      @uses += kode.uses
      @insert_at.codes << kode
      self
    end
    alias :<< :add_code 

    # create a new linear block after this block. Linear means there is no brach needed from this one
    # to the new one. Usually the new one just serves as jump address for a control statement
    # In code generation (assembly) , new new_block is written after this one, ie zero runtime cost
    def new_block new_name
      new_b = Block.new( new_name , @function , @insert_at.next )
      @insert_at.set_next new_b
      return new_b
    end

    def set_next next_b 
      @next = next_b
    end
    # when control structures create new blocks (with new_block) control continues at some new block the
    # the control structure creates. 
    # Example: while, needs  2 extra blocks
    #          1 condition code, must be its own blockas we jump back to it
    #           -       the body, can actually be after the condition as we don't need to jump there
    #          2 after while block. Condition jumps here 
    # After block 2, the function is linear again and the calling code does not need to know what happened
    
    # But subsequent statements are still using the original block (self) to add code to
    # So the while expression creates the extra blocks, adds them and the code and then "moves" the insertion point along
    def insert_at block
      @insert_at = block
      self
    end

    # sugar to create instructions easily. 
    # any method will be passed on to the RegisterMachine and the result added to the block
    #  With this trick we can write what looks like assembler, 
    #  Example   b.instance_eval
    #                mov( r1 , r2 )
    #                add( r1 , r2 , 4)
    # end
    #           mov and add will be called on Machine and generate Inststuction that are then added 
    #             to the block
    # also symbols are supported and wrapped as register usages (for bare metal programming)
    def method_missing(meth, *args, &block)
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