require_relative '../common/transaction'
require_relative 'recent_items_handler'
class CreditCardRecentItemsHandler

  attr_reader :recent_items_handler

  def initialize(recent_items_handler)
    @recent_items_handler = recent_items_handler
  end

  def handle(page, final_balance, max_transaction_date)
    recent_items_handler.handle(page, final_balance, max_transaction_date)
  end

  def move_on(page)
    page.click_link 'previous statements'
  end
end
