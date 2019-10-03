module Vool
  class LambdaExpression < Expression
    attr_reader :args , :body , :clazz

    def initialize( args , body , clazz = nil)
      @args , @body = args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    # because of normalization (of send), slot_definition is called first,
    # to assign the block to a variable.
    #
    # This means we do the compiler here (rather than to_slot, which is in
    # fact never called)
    def to_slot_definition(compiler)
      compile(compiler) unless @parfait_block
      return SlotMachine::SlotDefinition.new(SlotMachine::LambdaConstant.new(parfait_block(compiler)) , [])
    end

    # create a block, a compiler for it, comile the bock and add the compiler(code)
    # to the method compiler for further processing
    def compile( compiler )
      parfait_block = self.parfait_block(compiler)
      block_compiler = SlotMachine::BlockCompiler.new( parfait_block , compiler.get_method )
      head = body.to_slot( block_compiler )
      block_compiler.add_code(head)
      compiler.add_method_compiler(block_compiler)
      nil
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
    end

    def to_s(depth=0)
      "Block #{args} #{body}"
    end
    # create the parfait block (parfait representation of the block, a Callable similar
    #  to CallableMethod)
    def parfait_block(compiler)
      return @parfait_block if @parfait_block
      @parfait_block = compiler.create_block( make_arg_type , make_frame(compiler))
    end

    private
    def make_arg_type(  )
      type_hash = {}
      @args.each {|arg| type_hash[arg] = :Object }
      Parfait::Type.for_hash( type_hash )
    end
    def make_frame(compiler)
      type_hash = {}
      @body.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        next if compiler.in_scope?(node.name)
        type_hash[node.name] = :Object
      end
      Parfait::Type.for_hash( type_hash )
    end

  end
end
