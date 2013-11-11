require_relative '../common/transaction'

class TransactionExtractor

  StatementEntry = Struct.new(:date, :narrative, :amount, :debit)

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def extract_from(table, final_balance)
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
      Transaction.new(Date.strptime(entry.date, '%d/%m/%Y'),
                      entry.narrative,
                      entry.amount,
                      account)
    end
  end


  def is_credit?(entry)
    entry.debit.nil? || entry.debit.empty?
  end

  class Extractor
    def is_present?(value)
      !String(value).empty?
    end

    def negate(amount)
      amount * -1
    end
    def to_pence(raw_amount)
      Integer(Float(raw_amount.gsub(/£|\+/, '')) * 100.00)
    end

  end

  class RecentItemsCurrentAccountExtractor  < Extractor
    def extract_statement_entry(row_cells)
      narrative = row_cells[1].text
      credit = row_cells[2].text
      debit = row_cells[3].text

      amount = is_present?(debit) ? debit : credit

      amount_in_pence = to_pence(amount)

      amount_in_pence = negate(amount_in_pence) if is_present?(debit)

      StatementEntry.new(row_cells[0].text, narrative, amount_in_pence, debit)
    end


  end

  class CreditCardExtractor  < Extractor
    def extract_statement_entry(row_cells)
      narrative = row_cells[1].text
      amount_raw = row_cells[2].text
      amount = negate(to_pence(amount_raw))
      StatementEntry.new(row_cells[0].text, narrative, amount)
    end
  end
  class BalanceRowExtractor
    def extract_statement_entry(row_cells)
      nil # ignore balance lines
    end
  end
  class OlderStatementCurrentAccountExtractor < Extractor
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
