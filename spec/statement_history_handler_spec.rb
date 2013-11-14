require 'rspec'
require_relative '../lib/statement_history_handler'
require 'capybara'

describe '#link_to_most_recent_statement' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/StatementsHistory.html")
  end

  it 'it finds the link' do
    link = StatementHistoryHandler.new.link_to_most_recent_statement(@session)
    link.should_not be_nil
  end
end
