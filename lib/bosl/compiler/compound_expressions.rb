module Bosl
  Compiler.class_eval do

#    attr_reader :values
    def on_array expession, context
      raise "not implemented"
    end
#    attr_reader :key , :value
    def on_association context
      raise "not implemented"
    end
    def on_hash context
      raise "not implemented"
    end
  end
end
