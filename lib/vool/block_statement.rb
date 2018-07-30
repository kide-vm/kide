module Vool
  class BlockStatement < Statement
    attr_reader :args , :body , :clazz

    def initialize( args , body , clazz = nil)
      @args , @body = args , body
      raise "no bod" unless @body
      @clazz = clazz
    end

    # because of normalization (of send), slot_definition is called first,
    # to assign the block to a variable.
    #
    # This means we do the compiler here (rather than to_mom, which is in
    # fact never called)
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Mom::BlockConstant.new(parfait_block(compiler)) , [])
    end

    # create a block, a compiler for it, comile the bock and add the compiler(code)
    # to the method compiler for further processing
    def to_mom( compiler )
      parfait_block = self.parfait_block(compiler)
      block_compiler = Risc::BlockCompiler.new( parfait_block , compiler.get_method )
      head = body.to_mom( block_compiler )
      block_compiler.add_mom(head)
      block_compiler
    end

    def each(&block)
      block.call(self)
      @body.each(&block)
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
      Parfait::NamedList.type_for( type_hash )
    end
    def make_frame(compiler)
      type_hash = {}
      @body.each do |node|
        next unless node.is_a?(LocalVariable) or node.is_a?(LocalAssignment)
        next if compiler.in_scope?(node.name)
        type_hash[node.name] = :Object
      end
      Parfait::NamedList.type_for( type_hash )
    end

  end
end
