module Vm
  class Value
  end
  
  
  class Word < Value
  end
  
  class Reference < Value
  end
  
  class MemoryReference < Reference
  end
  
  class ObjectReference < Reference
  end
end