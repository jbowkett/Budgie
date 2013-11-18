require 'rspec'
require_relative '../lib/previous_statements_handler'
require_relative '../lib/transaction_extractor'
require 'capybara'

describe '#extract_transactions' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/statement_back_a_page.html")
  end

  let (:account){ double(:account).as_null_object }
  it 'extracts the transactions' do
    previous_txns = PreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_transactions(@session)
    previous_txns.size.should == 21
  end
end
