require_relative 'login_details'
require_relative '../common/account'

def usage
  "Main <account no> <sortcode> <memorable date> <memorable name> <first school> <last school> <security code>"
end

if ARGV.length != 7
  puts usage
  exit(-1)
end

account_no     = ARGV[0]
sortcode       = ARGV[1]
memorable_date = ARGV[2]
memorable_name = ARGV[3]
first_school   = ARGV[4]
last_school    = ARGV[5]
security_code  = ARGV[6]

account = Account.new(account_no, sortcode)
login = LoginDetails.new(first_school, last_school, memorable_name, memorable_date, security_code)

login_step_one = LoginStepOneHandler.new(account)
login_step_two = LoginStepTwoHandler.new(login)
login_step_three = LoginStepThreeHandler.new(login)
balance = BalanceHandler.new(account)
recent_items = RecentItemsHandler.new(account)
previous_statements = PreviousStatementsHandler.new(account)

smile_extractor = SmileNavigator.new(login_step_one, login_step_two, login_step_three, balance, recent_items, previous_statements)
smile_extractor.extract
