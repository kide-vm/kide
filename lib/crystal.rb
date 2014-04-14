class Numeric
  def fits_u8?
    self >= 0 and self <= 255
  end
end
