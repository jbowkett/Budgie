class StatementHistoryHandler

  def move_on(page)
    link_to_most_recent_statement(page).click
  end

  def link_to_most_recent_statement(page)
    table = page.all('table.summarytable tbody tr')
    first_table_cell = table.first.all('td').first
    first_table_cell.all('a')
  end
end
