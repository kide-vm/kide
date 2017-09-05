module Vool
  module Hoister
    def hoist_condition( method )
      return [@condition] if @condition.is_a?(Vool::Named)
      local = method.create_tmp
      assign = LocalAssignment.new( local , @condition)
      [Vool::LocalVariable.new(local) , assign]
    end
  end
end
