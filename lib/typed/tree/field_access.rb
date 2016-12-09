module Typed
  module Tree
    class FieldAccess < Expression
      attr_accessor :receiver , :field
    end
  end
end
