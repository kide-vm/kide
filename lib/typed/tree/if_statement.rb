module Typed
  module Tree
    class IfStatement < Statement
      attr_accessor :branch_type , :condition , :if_true , :if_false
    end
  end
end
