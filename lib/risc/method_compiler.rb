module Risc

  # MethodCompiler is used to generate risc instructions for methods
  # and to instantiate the methods correctly.

  class MethodCompiler < CallableCompiler

    # Methods starts with a Label, both in risc and mom.
    # Pass in the callable(method) and the mom label that the method starts with
    def initialize( method , slot_label)
      super(method , slot_label)
    end

    def source_name
      "#{@callable.self_type.name}.#{@callable.name}"
    end

    # sometimes the method is used as source (tb reviewed)
    def source
      @callable
    end

  end
end
