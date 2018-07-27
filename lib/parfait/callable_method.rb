# A CallableMethod is static object that primarily holds the executable code.
# It is callable through it's binary code
# Additionally to the base class it has a name
#
# It's relation to the method a ruby programmer knows (called VoolMethod) is many to one,
# meaning one VoolMethod (untyped) has many CallableMethod implementations.
# The VoolMethod only holds vool code, no binary.


module Parfait

  class CallableMethod < Callable

    attr_reader :name

    def initialize( self_type , name , arguments_type , frame_type)
      @name = name
      super(self_type , arguments_type , frame_type)
    end

    def ==(other)
      return false unless other.is_a?(CallableMethod)
      return false if @name != other.name
      super
    end

    def rxf_reference_name
      "Method: " + @name.to_s
    end

    def inspect
      "#{@self_type.object_class.name}:#{name}(#{arguments_type.inspect})"
    end

    def each_method( &block )
      block.call( self )
      @next.each_method( &block ) if @next
    end

    def create_block(args , frame)
      add_block( Block.new(self_type , args , frame))
    end

    def add_block(bl)
      was = @blocks
      bl.set_next(was) if(was)
      @blocks = bl
    end

    def has_block(block)
      each_block{ |bl| return true if bl == block}
      false
    end
    def each_block(&bl)
      blo = blocks
      while( blo )
        yield(blo)
        blo = blo.next
      end
    end
  end
end
