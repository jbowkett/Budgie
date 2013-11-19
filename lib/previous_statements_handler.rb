class PreviousStatementsHandler

  attr_reader :transaction_extractor

  def initialize(transaction_extractor)
    @transaction_extractor = transaction_extractor
  end

  def handle(page)
    prev_txns = Array.new
    while page.has_link?('previous statement page') && page.has_no_css?('.error')

      prev_txns += extract_transactions(page)

      page.click_link 'previous statement page'
      sleep(2)
    end
    prev_txns
  end

  def extract_transactions(page)
    table = page.all('table.summarytable tbody tr')
    statement_details = lambda{|elem|elem.all('td').size != 5}
    statement = table.reject &statement_details
    transaction_extractor.extract_from(statement, -1).compact
  end
end
