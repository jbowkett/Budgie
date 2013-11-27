require 'rspec'
require_relative '../lib/recent_items_handler'
require_relative '../lib/transaction_extractor'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/recent_items.html")
    DataMapper.finalize
  end

  let(:account) { double(:account, :id => 1, :account_id => account_id, :sort_code => sort_code, :is_credit_card? => is_credit_card) }

  context 'for a positive balance' do
    let(:account_id) { '1234567' }
    let(:sort_code)  { '119185' }
    let(:is_credit_card) { false }
    it 'should extract the balance' do
      recent_items = RecentItemsHandler.new(TransactionExtractor.new(account)).handle(@session, 956.01)
      recent_items.size.should == 7
    end
  end
end
