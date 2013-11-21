require 'data_mapper'

class Account
  include DataMapper::Resource

  property :id,         Serial
  property :account_id, String
  property :sort_code,  String

  def initialize(account_id, sort_code)
    @account_id = account_id
    @sort_code = sort_code
  end

  def is_credit_card?
    sort_code.nil? || sort_code.empty?
  end
end
