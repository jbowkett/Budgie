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

  private

  def extract_statement_entries(table)
    table.map do |row|
      row_cells = row.all('td')
      next unless row_cells.size == 4
      credit = row_cells[1].text
      debit = row_cells[2].text
      StatementEntry.new(row_cells[0].text, credit, debit, row_cells[3].text)
    end
  end

  def extract_transactions(rows)
    rows.map do |entry|
      amount_in_pence = is_credit?(entry) ? to_pence(entry.credit) : negate(to_pence(entry.debit))
      negate(amount_in_pence) if account.is_credit_card?
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
    entry.debit.empty?
  end

  def to_pence(raw_amount)
    Float(raw_amount.gsub(/£|\+|-/, '')) * 100.00
  end
end
