class Account < Struct.new(:account_id, :sort_code)
  def is_credit_card?
    sort_code.nil? || sort_code.empty?
  end
end
