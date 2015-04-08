# to be precise, this should be an ObjectReference, as the Reference is a Value
# but we don't want to make that distinction all the time , so we don't.

# that does lead to the fact that we have Reference functions on the Object though 

class Object < Value

  def get_type()
    OBJECT_TYPE
  end

  # This is the crux of the object system. The class of an object is stored in the objects
  # memory (as opposed to an integer that has no memory and so always has the same class)
  #
  # In Salama we store the class in the Layout, and so the Layout is the only fixed
  # data that every object carries.
  def get_class()
    @layout.get_class()
  end

  def get_layout()
    @layout
  end
end
