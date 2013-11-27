require 'data_mapper'
require_relative 'category'
require_relative 'account'

class Transaction
  include DataMapper::Resource

  property :id,                Serial
  belongs_to :account,         :required => true
  belongs_to :category,        :required => false
  property :amount_in_pence,   Integer,    :required => true
  property :balance_in_pence,  Integer,    :required => true
  property :transaction_date,  DateTime,   :required => true
  property :narrative,         String,     :required => false
  property :category_override, String,     :required => false

end
