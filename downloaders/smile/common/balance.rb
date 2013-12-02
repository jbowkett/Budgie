require 'data_mapper'
require_relative 'account'

class Balance
  include DataMapper::Resource

  property :id,               Serial
  belongs_to :account
  property :balance_in_pence, Integer,  :required => true
  property :balance_date,     DateTime, :required => true
end
