module Typed
  module Tree
    class WhileStatement < Statement
      attr_accessor :branch_type , :condition , :statements
    end
  end
end
