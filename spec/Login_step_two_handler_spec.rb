require 'rspec'
require_relative '../lib/login_step_two_handler'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_two.html")
  end

  let(:security_code) { '9812' }
  let(:login_details) { double(:login_details, :security_code => security_code ) }

  it 'should fill out the second digit in the security code' do
    LoginStepTwoHandler.new(login_details).handle(@session)
    @session.find('#firstPassCodeDigit')['value'].should == security_code[1]
  end

  it 'should fill out the third digit in the security code' do
    LoginStepTwoHandler.new(login_details).handle(@session)
    @session.find('#secondPassCodeDigit')['value'].should == security_code[2]
  end
end
