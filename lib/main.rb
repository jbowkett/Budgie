require_relative 'login_details'
require_relative '../common/account'

def usage
  "Main <account no> <sortcode> <memorable date> <memorable name> <first school> <last school>"
end

if ARGV.length != 6
  puts usage
  exit(-1)
end

account_no     = ARGV[0]
sortcode       = ARGV[1]
memorable_date = ARGV[2]
memorable_name = ARGV[3]
first_school   = ARGV[4]
last_school    = ARGV[5]

account = Account.new(account_no, sortcode)
login = LoginDetails.new(first_school, last_school, memorable_name, memorable_date)

login_step_one = LoginStepOneHandler.new
login_step_two = LoginStepTwoHandler.new(account)
login_step_three = LoginStepThreeHandler.new(account, login)
recent_items = RecentItemsHandler.new(account)
previous_statements = PreviousStatementsHandler.new(account)

smile_extractor = SmileNavigator.new(login_step_one, login_step_two, login_step_three, recent_items, previous_statements)
smile_extractor.extract
