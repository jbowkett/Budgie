require 'data_mapper'

class Account
  include DataMapper::Resource

  property :id,         Serial
  property :account_id, String, :required => true
  property :sort_code,  String, :required => false

  def is_credit_card?
    sort_code.nil? || sort_code.empty?
  end
end
