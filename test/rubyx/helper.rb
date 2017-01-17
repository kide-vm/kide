require_relative '../helper'

module Rubyx
  module CompilerHelper

    def in_Test(statements)
      "class Test ; #{statements} ; end"
    end
    
    def in_Space(statements)
      "class Space ; #{statements} ; end"
    end

    def as_main(statements)
      in_Space("def main ; #{statements}; end")
    end
  end
end
