module Typed
  class ClassStatement < Statement
    attr_accessor :name , :derives , :statements
  end

  class ClassField < Statement
    attr_accessor :name , :type
  end
end
