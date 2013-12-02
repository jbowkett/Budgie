require_relative 'extraction'
class CreditCardPreviousStatementsHandler
  include Extraction

  attr_reader :transaction_extractor

  def initialize(transaction_extractor)
    @transaction_extractor = transaction_extractor
  end

  def handle(page, max_transaction_date)
    prev_txns = Array.new
    while has_previous_stmts_link(page)

      prev_txns += extract_transactions(page)

      break if prev_txns.last.transaction_date <= max_transaction_date
      page.click_link 'previous'
      sleep(2)
    end
    prev_txns += extract_transactions(page)

    prev_txns.reject{|txn| txn.transaction_date <= max_transaction_date }
  end

  def has_previous_stmts_link(page)
    page.has_link?('previous') && page.has_no_css?('.error')
  end

  def extract_transactions(page)
    table = page.all('table.summarytable tbody tr')
    statement_details = lambda{|elem|elem.all('td').size != 3}
    statement = table.reject &statement_details
    balance = extract_balance(page)
    transaction_extractor.extract_from(statement, balance).compact
  end

  def extract_balance(page)
    table_cells = page.all('table table table tbody tr td')

    balance_index = 0
    table_cells.each_with_index do |val, index|
      if val.text == 'statement balance'
        balance_index = index +1
      end
    end
    balance_str = table_cells[balance_index].text
    balance = negate(to_pence(balance_str))
    if balance_str =~ /.*-.*/
      return negate(balance)
    end
    balance
  end
end
