module Preloader
  def get_preload(preload)
    return "" unless preload
    preload = Vool::Builtin.builtin.keys.join(";") if(preload == "all" )
    preload.split(";").collect do |loads|
      raise "no preload #{loads}" unless Vool::Builtin.builtin[loads]
      clazz , meth = loads.split(".")
      "class #{clazz}; #{Vool::Builtin.builtin[loads]};end;"
    end.join
  end
  def preload
    get_preload(@preload)
  end
end
