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

    def initialize(name , function , next_block )
      super()
      @function = function
      @name = name.to_sym
      @next = next_block
      @branch = nil
      @codes = []
      # keeping track of register usage, left (assigns) or right (uses)
      @assigns = []
      @uses = []
    end

    attr_reader :name  , :next , :codes , :function , :assigns , :uses
    attr_accessor :branch
    
    def reachable ret = []
      add_next ret
      add_branch ret
      ret
    end

    def do_add kode
      kode.assigns.each { |a| (@assigns << a) unless @assigns.include?(a) }
      kode.uses.each { |use| (@uses << use) unless (@assigns.include?(use) or @uses.include?(use)) }
      #puts "IN ADD #{name}#{uses}" 
      @codes << kode
    end

    def set_next next_b 
      @next = next_b
    end

    # returns if this is a block that ends in a call (and thus needs local variable handling)
    def call_block?
      return false unless codes.last.is_a?(CallInstruction)
      return false unless codes.last.opcode == :call
      codes.dup.reverse.find{ |c| c.is_a? StackInstruction }
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

    private
    # helper for determining reachable blocks 
    def add_next ret
      return if @next.nil?
      return if ret.include? @next
      ret << @next
      @next.reachable ret
    end
    # helper for determining reachable blocks 
    def add_branch ret
      return if @branch.nil?
      return if ret.include? @branch
      ret << @branch
      @branch.reachable ret
    end
  end
end