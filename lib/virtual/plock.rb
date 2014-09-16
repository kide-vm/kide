module Virtual
  # Plock (Proc-Block) is mostly a Block but also somewhat Proc-ish: A Block that carries data.
  #
  # Data in a Block is usefull in the same way data in objects is. Plocks being otherwise just code.
  #
  # But the concept is not quite straigtforwrd: If one thinks of a Plock embedded in a normal method,
  # the a data in the Plock would be static data. In OO terms this comes quite close to a Proc, if the data is the local
  # variables. Quite possibly they shall be used to implement procs, but that is not the direction now.
  #
  # For now we use Plocks behaind the scenes as it were. In the code that you never see, method invocation mainly.
  # 
  # In terms of implementation the Plock is a Block with data (Not too much data, mainly a couple of references).
  # The block writes it's instructions as normal, but a jump is inserted as the last instruction. The jump is to the 
  # next block, over the data that is inserted after the block code (and so before the next)
  #
  # It follows that Plocks should be linear blocks.
  class Plock < Block
    
    def initialize(name , method , next_block )
      super
      @data = []
      @branch_code = RegisterMachine.instance.b next_block
    end

    def set_next next_b
      super
      @branch_code = RegisterMachine.instance.b next_block
    end

    # Data gets assembled after methods
    def add_data o
      return if @objects.include? o
      raise "must be derived from Code #{o.inspect}" unless o.is_a? Register::Code
      @data << o # TODO check type , no basic values allowed (must be wrapped)
    end

    # Code interface follows. Note position is inheitted as is from Code

    # length of the Plock is the length of the block, plus the branch, plus data.
    def mem_length
      len = @data.inject(super) {| sum  , item | sum + item.mem_length}
      len + @branch_code.mem_length
    end

    # again, super +  branch plus data
    def link_at pos , context
      super(pos , context)
      @branch_code.link_at pos , context
      @data.each do |code|
        code.link_at(pos , context)
        pos += code.mem_length
      end
    end

    # again, super +  branch plus data
    def assemble(io)
      super
      @branch_code.assemble(io)
      @data.each do |obj|
        obj.assemble io
      end
    end
  end
end
