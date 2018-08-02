module Parfait

  # A CallableMethod is static object that primarily holds the executable code.
  # It is callable through it's binary code
  #
  # It's relation to the method a ruby programmer knows (called VoolMethod) is many to one,
  # meaning one VoolMethod (untyped) has many CallableMethod implementations.
  # The VoolMethod only holds vool code, no binary.
  #
  # CallableMethods are bound to a known type (self_type) and have known argument
  # and local variables. All variable resolution inside the method is exact (static),
  # only method resolution may be dynamic
  class CallableMethod < Callable

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
      block_name = "#{@name}_block".to_sym #TODO with id, to distinguish
      add_block( Block.new(block_name , self_type , args , frame))
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
