# this is not a "normal" ruby file, ie it is not required by salama
# instead it is parsed by salama to define part of the program that runs

class Array < BaseObject
  #many basic array functions can not be defined in ruby, such as
  # get/set/length/add/delete
  # so they must be defined as CompiledMethods in Salama::Kernel
   
end
