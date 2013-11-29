class PreviousStatementsHandler

  attr_reader :transaction_extractor

  def initialize(transaction_extractor)
    @transaction_extractor = transaction_extractor
  end

  def handle(page, max_transaction_date)
    prev_txns = Array.new
    while has_previous_stmts_link(page)

      prev_txns += extract_transactions(page)

      break if prev_txns.last.transaction_date <= max_transaction_date
      page.click_link 'previous statement page'
      sleep(2)
    end
    prev_txns += extract_transactions(page)
    prev_txns.reject{|txn| txn.transaction_date <= max_transaction_date }
  end

  def has_previous_stmts_link(page)
    page.has_link?('previous statement page') && page.has_no_css?('.error')
  end

  def extract_transactions(page)
    table = page.all('table.summarytable tbody tr')
    statement_details = lambda{|elem|elem.all('td').size != 5}
    statement = table.reject &statement_details
    transaction_extractor.extract_from(statement, -1).compact
  end
end
