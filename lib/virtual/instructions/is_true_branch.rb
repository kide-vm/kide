module Virtual

  # implicit means there is no explcit test involved.
  # normal ruby rules are false and nil are false, EVERYTHING else is true (and that includes 0)
  class IsTrueBranch < Branch
  end

end
