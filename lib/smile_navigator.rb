require 'capybara'

class SmileNavigator
  attr_reader :login_step_one, :login_step_two, :login_step_three, :balance, :recent_items, :previous_statements, :session
  private     :login_step_one, :login_step_two, :login_step_three, :balance, :recent_items, :previous_statements, :session

  def initialize(login_step_one, login_step_two, login_step_three, balance, recent_items, previous_statements)
    @login_step_one, @login_step_two, @login_step_three = login_step_one, login_step_two, login_step_three
    @login_step_three, @balance, @recent_items = login_step_three, balance, recent_items
    @previous_statements = previous_statements
    @session = init_session
  end

  def init_session
    Capybara.javascript_driver = :webkit
    puts "driver set."
    Capybara.run_server = false
    Capybara::Session.new(:selenium)
  end

  def extract
    session.visit("https://banking.smile.co.uk/SmileWeb/start.do")
    sleep(2)
    login_step_one.handle(session) # enter account details
    sleep(2)
    login_step_one.move_on(session)
    sleep(2)
    login_step_two.handle(session) # enter secure passcode
    sleep(2)
    login_step_two.move_on(session)
    sleep(2)
    login_step_three.handle(session) # enter secure details
    sleep(2)
    login_step_three.move_on(session)
    sleep(2)
    total_balance = balance.extract_balance(session)  # maybe get the balance back?..call it extract balance
    sleep(2)
    balance.move_on(session)
    sleep(2)
    recent_txns = recent_items.handle(session)
    sleep(2)
    prev_txns = previous_statements.handle(session)
    recent_txns + prev_txns
  end
end


