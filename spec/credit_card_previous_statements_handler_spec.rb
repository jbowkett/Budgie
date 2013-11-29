require 'rspec'
require_relative '../lib/credit_card_previous_statements_handler'
require_relative '../lib/transaction_extractor'
require 'capybara'

describe '#extract_transactions' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    DataMapper.finalize
  end
  context 'for a credit card' do
    let (:account){ double(:account, :is_credit_card? => true).as_null_object }
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/statement_back_a_page_credit_card.html")
    end

    it 'extracts the transactions' do
      previous_txns = CreditCardPreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_transactions(@session)
      previous_txns.size.should == 8
    end

    it 'negates the amounts on the transactions' do
      previous_txns = CreditCardPreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_transactions(@session)
      previous_txns.last.amount_in_pence.should == -18987
      previous_txns.first.amount_in_pence.should == -208
      previous_txns[1].amount_in_pence.should == 2000
    end

    it 'extracts the balance' do
      balance = CreditCardPreviousStatementsHandler.new(TransactionExtractor.new(account)).extract_balance(@session)
      balance.should == -65421
    end

  end
end
