module Preloader
  def get_preload(preload)
    return "" unless preload
    if( preload == "all" )
      loading = Vool::Builtin.builtin.keys
    else
      loading = preload.split(";")
    end
    loading.collect { |loads| Vool::Builtin.load_builtin(loads)}.join(";") + ";"
  end
  def preload
    get_preload(@preload)
  end
end
