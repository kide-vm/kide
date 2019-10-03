module Preloader
  def get_preload(preload)
    return "" unless preload
    if( preload == "all" )
      loading = Sol::Builtin.builtin.keys
    else
      loading = preload.split(";")
    end
    loading.collect { |loads| Sol::Builtin.load_builtin(loads)}.join(";") + ";"
  end
  def preload
    get_preload(@preload)
  end
end
