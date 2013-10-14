class BalanceHandler

  BalanceRow = Struct.new(:balance, :account_identifier, :link)

  attr_reader :account
  private :account
  def initialize(account)
    @account = account
  end

  def extract_balance(page)
    balance_row = find_balance_row_in(page)
    balance_from(balance_row)
  end

  def move_on(page)
    find_balance_row_in(page).link.click
  end

  private

  def find_balance_row_in(page)
    table = page.all('table tbody tr td.verttop table tbody tr td.verttop table tbody tr td.verttop table tbody tr')

    rows = table.map do |row|
      row_cells = row.all('td')
      BalanceRow.new(row_cells[1].text, row_cells[2].text, row.all('a').first) unless row_cells.size < 3
    end
    rows.compact.select { |row| row.account_identifier =~ account_matcher }.first
  end

  def balance_from(the_row)
    balance = Float(the_row.balance.gsub(/£|\+|-/, ''))
    balance *= -1 if the_row.balance =~ /.*-/
    balance
  end

  def account_matcher
    Regexp.new ".*#{account.account_id}.*"
  end
end
