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
end
