module Vool
  class FunctionStatement < Statement
    attr_accessor :return_type , :name , :parameters, :statements , :receiver
  end
end
