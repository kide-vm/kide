module Risc

  # MethodCompiler is used to generate risc instructions for methods
  # and to instantiate the methods correctly.

  class MethodCompiler < CallableCompiler
    include Util::CompilerList

    # Methods starts with a Label, both in risc and mom.
    # Pass in the callable(method) and the mom label that the method starts with
    def initialize( method , mom_label)
      super(method , mom_label)
    end

    #include block_compilers constants
    def constants
      block_compilers.inject(@constants.dup){|all, compiler| all += compiler.constants}
    end

    def source_name
      "#{@callable.self_type.name}.#{@callable.name}"
    end

    # sometimes the method is used as source (tb reviewed)
    def source
      @callable
    end

    def add_block_compiler(compiler)
      @block_compilers << compiler
    end

    # translate this method, which means the method itself and all blocks inside it
    # returns the array (of assemblers) that you pass in as collection
    def translate_method(  translator , collection)
      collection << translate_cpu( translator )
      @block_compilers.each do |block_compiler|
        collection << block_compiler.translate_cpu(translator)
      end
      collection
    end
  end
end
