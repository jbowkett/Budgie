module Extraction

  def is_present?(value)
    !String(value).empty?
  end

  def negate(amount)
    amount * -1
  end

  def to_pence(raw_amount)
    Integer(Float(raw_amount.gsub(/£|\+/, '')) * 100.00)
  end
end
