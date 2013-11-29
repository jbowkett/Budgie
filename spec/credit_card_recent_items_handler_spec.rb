require 'rspec'
require_relative '../lib/credit_card_recent_items_handler'
require_relative '../lib/transaction_extractor'
require 'capybara'
require 'date'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec

    DataMapper.finalize
  end

  let(:account) { double(:account, :id => 1, :account_id => account_id, :sort_code => sort_code, :is_credit_card? => is_credit_card) }

  context 'for a credit card account' do
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/recent_items_credit_card.html")
    end

    let(:account_id) { '1234567890876567' }
    let(:sort_code)  { nil }
    let(:is_credit_card) { true }
    it 'should extract the recent transactions' do
      recent_items = CreditCardRecentItemsHandler.new(RecentItemsHandler.new(TransactionExtractor.new(account))).handle(@session, -46863, DateTime.parse('01-01-2000 11:58'))
      recent_items.size.should == 2
    end
  end
end
