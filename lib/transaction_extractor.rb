require_relative '../common/transaction'
require 'delegate'
require 'date'

class TransactionExtractor

  StatementEntry = Struct.new(:date, :narrative, :amount, :balance_in_pence)

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def extract_from(table, closing_balance_in_pence)
    rows = extract_statement_entries(table, closing_balance_in_pence)
    extract_transactions(rows.compact)
  end

  def extract_statement_entries(table, closing_balance_in_pence)
    sort!(table)
    table = decorate_with_timestamps(table)

    current_balance_in_pence = closing_balance_in_pence
    table.map do |row|
      row_cells = row.all('td')

      extractor = EXTRACTORS.fetch(row_cells.length)
      extractor.extract_statement_entry(row.timestamp, row_cells, current_balance_in_pence).tap do |stmt_entry|
        current_balance_in_pence -= stmt_entry.amount unless stmt_entry.nil?
      end
    end.compact
  end

  def decorate_with_timestamps(table)
    table.map do |row|
      row_cells = row.all('td')
      raw_date = row_cells[0].text
      timestamp = DateTime.parse(raw_date)
      RowWrapper.new(timestamp, row)
    end
  end

  def sort!(table)
    last_row = table.last.all('td')
    first_row = table.first.all('td')

    # balance row
    if last_row.size < 2
      last_row = table[-2].all('td')
    end

    last_row_date = Date.parse(last_row[0].text)
    first_row_date = Date.parse(first_row[0].text)
    if last_row_date > first_row_date
      table.reverse!
    end
  end

  def extract_transactions(rows)
    rows.map do |entry|
      Transaction.new(entry.date,
                      entry.narrative,
                      entry.amount,
                      entry.balance_in_pence,
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
    def extract_statement_entry(timestamp, row_cells, balance_after_transaction)
      narrative = row_cells[1].text
      credit = row_cells[2].text
      debit = row_cells[3].text

      amount = is_present?(debit) ? debit : credit

      amount_in_pence = to_pence(amount)

      amount_in_pence = negate(amount_in_pence) if is_present?(debit)

      StatementEntry.new(timestamp, narrative, amount_in_pence, balance_after_transaction)
    end


  end

  class CreditCardExtractor  < Extractor
    def extract_statement_entry(timestamp, row_cells, balance_after_transaction)
      narrative = row_cells[1].text
      amount_raw = row_cells[2].text
      amount = negate(to_pence(amount_raw))
      StatementEntry.new(timestamp, narrative, amount, balance_after_transaction)
    end
  end
  class BalanceRowExtractor
    def extract_statement_entry(timestamp, row_cells, balance_after_transaction)
      nil # ignore balance lines
    end
  end
  class OlderStatementCurrentAccountExtractor < Extractor
    def extract_statement_entry(timestamp, row_cells, balance_after_transaction)
      narrative = row_cells[1].text
      credit = row_cells[2].text
      debit = row_cells[3].text

      return nil if !is_present?(debit) && !is_present?(credit)

      balance_raw = row_cells[4].text

      balance = to_pence(balance_raw.gsub('-',''))
      balance = negate(balance) if balance_raw =~ /.*-.*/

      amount = is_present?(debit) ? debit : credit
      amount_in_pence = to_pence(amount)
      amount_in_pence = negate(amount_in_pence) if is_present?(debit)

      StatementEntry.new(timestamp, narrative, amount_in_pence, balance)
    end
  end

  class RowWrapper < SimpleDelegator

    attr_reader :row, :timestamp
    def initialize(timestamp, row)
      @row = row
      @timestamp = timestamp
      super(row)
    end
  end

  private
  EXTRACTORS = {
      1 => BalanceRowExtractor.new,
      3 => CreditCardExtractor.new,
      4 => RecentItemsCurrentAccountExtractor.new,
      5 => OlderStatementCurrentAccountExtractor.new
  }
end
