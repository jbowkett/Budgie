require 'rspec'
require_relative '../lib/recent_items_handler'
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

  context 'for a current account' do
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/recent_items.html")
    end

    let(:account_id) { '1234567' }
    let(:sort_code)  { '119185' }
    let(:is_credit_card) { false }
    it 'should extract the recent transactions' do
      recent_items = RecentItemsHandler.new(TransactionExtractor.new(account)).handle(@session, 956.01, DateTime.parse('01-01-2000 11:58'))
      recent_items.size.should == 7
    end

    it 'should filter out transactions older than max transaction date' do
      recent_items = RecentItemsHandler.new(TransactionExtractor.new(account)).handle(@session, 956.01, DateTime.parse('30-09-2013 11:59'))
      recent_items.size.should == 4
    end
  end

  context 'for a credit card account' do
    before do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/recent_items_credit_card.html")
    end

    let(:account_id) { '1234567890876567' }
    let(:sort_code)  { nil }
    let(:is_credit_card) { true }
    it 'should extract the recent transactions' do
      recent_items = RecentItemsHandler.new(TransactionExtractor.new(account)).handle(@session, -46863, DateTime.parse('01-01-2000 11:58'))
      recent_items.size.should == 2
    end
  end
end
