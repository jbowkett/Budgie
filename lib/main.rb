require_relative 'login_details'
require_relative '../common/account'
require_relative 'login_step_one_handler'
require_relative 'login_step_two_handler'
require_relative 'login_step_three_handler'
require_relative 'balance_handler'
require_relative 'recent_items_handler'
require_relative 'transaction_extractor'
require_relative 'statement_history_handler'
require_relative 'previous_statements_handler'

def usage
  'Main <memorable date> <memorable name> <first school> <last school> <security code> <account no> [sortcode]'
end

if ARGV.length != 6 && ARGV.length != 7
  puts usage
  exit(-1)
end

memorable_date = ARGV[0]
memorable_name = ARGV[1]
first_school   = ARGV[2]
last_school    = ARGV[3]
security_code  = ARGV[4]
account_no     = ARGV[5]
sortcode       = ARGV.length == 7 ? ARGV[6] : nil

account = Account.new(account_no, sortcode)
login = LoginDetails.new(first_school, last_school, memorable_name, memorable_date, security_code)

login_step_one = LoginStepOneHandler.new(account)
login_step_two = LoginStepTwoHandler.new(login)
login_step_three = LoginStepThreeHandler.new(login)
balance = BalanceHandler.new(account)
recent_items = RecentItemsHandler.new(TransactionExtractor.new(account))
statement_history = StatementHistoryHandler.new
previous_statements = PreviousStatementsHandler.new(TransactionExtractor.new(account))

smile_extractor = SmileNavigator.new(login_step_one, login_step_two, login_step_three, balance, recent_items, statement_history, previous_statements)
txns = smile_extractor.extract

txns.each do |txn|
  puts "#{txn.date}\t#{txn.narrative}\t#{txn.amount_in_pence}\t#{txn.balance_in_pence}"
end
