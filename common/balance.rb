require 'data_mapper'

class Balance
  include DataMapper::Resource

  property :id,               Serial
  property :account_id,       String
  property :sort_code,        String
  property :balance_in_pence, Integer
  property :balance_date,     DateTime
end
