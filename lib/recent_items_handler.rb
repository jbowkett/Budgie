require_relative '../common/transaction'
class RecentItemsHandler

  attr_reader :transaction_extractor
  private :transaction_extractor
  def initialize(transaction_extractor)
    @transaction_extractor = transaction_extractor
  end

  def handle(page, final_balance)
    table = page.all('table.summarytable tbody tr')
    transaction_extractor.extract_from(table, final_balance)
  end

  def move_on(page)
    page.click_link 'view previous statements'
  end

end
