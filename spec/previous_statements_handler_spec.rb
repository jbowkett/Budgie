require 'rspec'
require_relative '../lib/previous_statements_handler'
require_relative '../lib/transaction_extractor'
require 'capybara'

describe '#extract_transactions' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    DataMapper.finalize
  end
  context 'for a regular account' do
    let (:account){ double(:account, :is_credit_card? => false).as_null_object }
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/statement_back_a_page.html")
    end

    it 'extracts the transactions' do
      previous_txns = PreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_transactions(@session)
      previous_txns.size.should == 21
    end
  end

  context 'for a credit card' do
    let (:account){ double(:account, :is_credit_card? => true).as_null_object }
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/statement_back_a_page_credit_card.html")
    end

    it 'extracts the transactions' do
      previous_txns = PreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_transactions(@session)
      previous_txns.size.should == 8
    end
  end
end
