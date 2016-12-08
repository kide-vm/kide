module Typed
  Compiler.class_eval do

#    attr_reader :values
    def on_array statement, context
    end
#    attr_reader :key , :value
    def on_association context
    end
    def on_hash context
    end
  end
end
