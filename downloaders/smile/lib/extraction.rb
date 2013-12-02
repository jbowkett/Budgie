module Extraction

  def is_present?(value)
    !String(value).empty?
  end

  def negate(amount)
    amount * -1
  end

  def to_pence(raw_amount)
    amount = Integer(Float(raw_amount.gsub(/£|\+|-/, '')) * 100.00)
    raw_amount =~ /.*-.*/ ? negate(amount) : amount
  end
end
