require 'rspec'
require_relative '../lib/login_step_one_handler'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_one.html")
  end

  let(:account) { double(:account, :account_id => account_id, :sort_code => sort_code, :is_credit_card? => is_credit_card) }

  context 'for a regular account' do
    let(:account_id) { '1234567' }
    let(:sort_code)  { '089185' }
    let(:is_credit_card) { false }
    it 'should fill out the spi details' do
      LoginStepOneHandler.new(account).handle(@session)
      @session.find('#accountnumber')['value'].should == account_id
      @session.find('#sortcode')['value'].should == sort_code
    end
  end

  context 'for a credit card' do
    let(:account_id) { '4988249312344567' }
    let(:sort_code)  { '' }
    let(:is_credit_card) { true }

    it 'should fill out the spi details' do
      LoginStepOneHandler.new(account).handle(@session)
      @session.find('#visanumber')['value'].should == account_id
    end
  end
end
