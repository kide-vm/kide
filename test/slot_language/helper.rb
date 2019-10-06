require_relative "../helper"

module SlotLanguage
  module SlotHelper
    def compile(input)
      SlotCompiler.compile(input)
    end
    def compile_class(input)
      compile(input).class
    end
  end
  module SlotToHelper
    def setup
      Parfait.boot!({})
      @compiler = SlotMachine::SlotCollection.compiler_for( :Space , :main,{},{})
    end
  end
end
