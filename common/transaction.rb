require 'data_mapper'

class Transaction
  include DataMapper::Resource

  property :id,               Serial
  belongs_to :account
  property :amount_in_pence,  Integer
  property :balance_in_pence, Integer
  property :transaction_date, DateTime
  property :narrative,        String

  def initialize(transaction_date, narrative, amount_in_pence, balance_in_pence, account)
    @transaction_date = transaction_date
    @account = account
    @amount_in_pence = amount_in_pence
    @balance_in_pence = balance_in_pence
    @narrative = narrative
  end
end
