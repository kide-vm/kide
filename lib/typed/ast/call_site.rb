module Typed
  module Tree
    class CallSite < Expression
      attr_accessor :name , :receiver , :arguments
    end
  end
end
