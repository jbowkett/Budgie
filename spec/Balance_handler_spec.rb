require 'rspec'
require_relative '../lib/balance_handler'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/home_balances.html")
  end

  let(:account) { double(:account, :account_id => account_id, :sort_code => sort_code, :is_credit_card? => is_credit_card) }

  context 'for a positive balance' do
    let(:account_id) { '1234567' }
    let(:sort_code)  { '119185' }
    let(:is_credit_card) { false }
    it 'should extract the balance' do
      balance = BalanceHandler.new(account).extract_balance(@session)
      balance.should == 156.01
    end
  end

  context 'for a negative balance' do
    let(:account_id) { '23456790' }
    let(:sort_code)  { '119286' }
    let(:is_credit_card) { false }
    it 'should extract the balance' do
      balance = BalanceHandler.new(account).extract_balance(@session)
      balance.should == -165.12
    end
  end

  context 'for a credit card' do
    let(:account_id) { '1234567890123456' }
    let(:sort_code)  { '' }
    let(:is_credit_card) { true }

    it 'should extract the balance' do
      balance = BalanceHandler.new(account).extract_balance(@session)
      balance.should == 141.11
    end
  end
end
