require_relative 'balance'
require_relative 'transaction'
require_relative 'account'

class BudgieStorage

  attr_reader :balance_storage, :transaction_storage, :account_storage

  def initialize(balance_storage = Balance, transaction_storage = Transaction, account_storage = Account)
    @balance_storage = balance_storage
    @transaction_storage = transaction_storage
    @account_storage = account_storage
  end

  def persist(statement)
    account = statement.account
    txns = statement.transactions
    balance = balance_storage.create({:account => account,
                                      :balance_in_pence => statement.current_balance_in_pence,
                                      :balance_date => statement.date})
    txns.map(&:save)
  end

  def account(account_id, sort_code)
    account_storage.first_or_create({:account_id => account_id, :sort_code => sort_code})
  end

  def max_transaction_date
    transaction_storage.max(:transaction_date)
  end
end
