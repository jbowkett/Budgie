require 'rspec'
require_relative '../lib/login_step_three_handler'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three.html")
  end

  let(:memorable_name) { 'memorable name' }
  let(:login_details) { double(:login_details, :memorable_name => memorable_name ) }

  it 'should fill out the second digit in the security code' do
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#memorablename')['value'].should == memorable_name
  end

  xit 'should fill out the third digit in the security code' do
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#secondPassCodeDigit')['value'].should == security_code[2]
  end
end
