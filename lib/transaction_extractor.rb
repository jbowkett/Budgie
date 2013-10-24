require_relative '../common/transaction'

class TransactionExtractor

  StatementEntry = Struct.new(:date, :narrative, :credit, :debit)

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def extract_from(table)
    rows = extract_statement_entries(table)
    extract_transactions(rows.compact)
  end

  def extract_statement_entries(table)
    table.map do |row|
      row_cells = row.all('td')

      extractor = EXTRACTORS.fetch(row_cells.length)
      extractor.extract_statement_entry(row_cells)
    end.compact
  end

  def extract_transactions(rows)
    rows.map do |entry|
      if account.is_credit_card?
        amount_in_pence = negate(to_pence(entry.credit))
      else
        amount_in_pence = is_credit?(entry) ? to_pence(entry.credit) : negate(to_pence(entry.debit))
      end
      Transaction.new(Date.strptime(entry.date, '%d/%m/%Y'),
                      entry.narrative,
                      amount_in_pence,
                      account)
    end
  end

  def negate(amount)
    amount * -1
  end

  def is_credit?(entry)
    entry.debit.nil? || entry.debit.empty?
  end

  def to_pence(raw_amount)
    Float(raw_amount.gsub(/£|\+/, '')) * 100.00
  end

  class RecentItemsCurrentAccountExtractor
    def extract_statement_entry(row_cells)
      narrative = row_cells[1].text
      credit = row_cells[2].text
      debit = row_cells[3].text
      StatementEntry.new(row_cells[0].text, narrative, credit, debit)
    end
  end

  class CreditCardExtractor
    def extract_statement_entry(row_cells)
      narrative = row_cells[1].text
      amount = row_cells[2].text
      StatementEntry.new(row_cells[0].text, narrative, amount, nil)
    end
  end
  class BalanceRowExtractor
    def extract_statement_entry(row_cells)
      nil # ignore balance lines
    end
  end
  class OlderStatementCurrentAccountExtractor
    def extract_statement_entry(row_cells)
      narrative = row_cells[1].text
      credit = row_cells[2].text
      debit = row_cells[3].text
      balance = row_cells[4].text
      StatementEntry.new(row_cells[0].text, narrative, credit, debit)
    end
  end

  private
  EXTRACTORS = {
      1 => BalanceRowExtractor.new,
      3 => CreditCardExtractor.new,
      4 => RecentItemsCurrentAccountExtractor.new,
      #5 => OlderStatementCurrentAccountExtractor.new
  }
end
