require 'data_mapper'
require_relative '../common/account'
require_relative '../common/budgie_storage'
require_relative 'smile_navigator'
require_relative 'login_details'
require_relative 'login_step_one_handler'
require_relative 'login_step_two_handler'
require_relative 'login_step_three_handler'
require_relative 'balance_handler'
require_relative 'recent_items_handler'
require_relative 'transaction_extractor'
require_relative 'statement_history_handler'
require_relative 'previous_statements_handler'

def usage
  'Main <memorable date> <memorable name> <first school> <last school> <birth place> <security code> <account no> [sortcode]'
end

if ARGV.length != 7 && ARGV.length != 8
  puts usage
  exit(-1)
end

memorable_date = Date.parse(ARGV[0])
memorable_name = ARGV[1]
first_school   = ARGV[2]
last_school    = ARGV[3]
birth_place    = ARGV[4]
security_code  = ARGV[5]
account_no     = ARGV[6]
sortcode       = ARGV.length == 8 ? ARGV[7] : nil

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://localhost/budgie')
DataMapper.finalize

storage = BudgieStorage.new
account = storage.account(account_no, sortcode)
login = LoginDetails.new(first_school, last_school, birth_place, memorable_name, memorable_date, security_code)

login_step_one = LoginStepOneHandler.new(account)
login_step_two = LoginStepTwoHandler.new(login)
login_step_three = LoginStepThreeHandler.new(login)
balance = BalanceHandler.new(account)
recent_items = RecentItemsHandler.new(TransactionExtractor.new(account))
statement_history = StatementHistoryHandler.new
previous_statements = PreviousStatementsHandler.new(TransactionExtractor.new(account))

smile_extractor = SmileNavigator.new(account, login_step_one, login_step_two, login_step_three, balance, recent_items, statement_history, previous_statements)
stmt = smile_extractor.extract
storage.persist(stmt)
puts 'done.'
